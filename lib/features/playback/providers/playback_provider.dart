import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/dialogue_choice.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../domain/entities/requirement_flag.dart';
import '../../../domain/entities/reward_flag.dart';
import '../../dialogue_editor/providers/dialogue_graph_provider.dart';

part 'playback_provider.g.dart';

class PlaybackState {
  const PlaybackState({
    required this.nodes,
    required this.choices,
    required this.requirementFlags,
    required this.rewardFlags,
    required this.currentNodeId,
    required this.visitedNodes,
    required this.flagMap,
  });

  final List<DialogueNode> nodes;
  final List<DialogueChoice> choices;

  final Map<String, List<RequirementFlag>> requirementFlags;
  final Map<String, List<RewardFlag>> rewardFlags;

  final String currentNodeId;
  final List<String> visitedNodes;
  final Map<String, bool> flagMap;

  DialogueNode get currentNode =>
      nodes.firstWhere((n) => n.id == currentNodeId);

  List<DialogueChoice> get currentChoices => (choices
        .where((c) => c.fromNodeId == currentNodeId && c.toNodeId != null)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)));

  bool isChoiceLocked(String choiceId) {
    final reqs = requirementFlags[choiceId] ?? [];
    for (final req in reqs) {
      final currentValue = flagMap[req.flagName] ?? false;
      if (currentValue != req.requiredValue) return true;
    }
    return false;
  }

  bool get isDeadEnd => currentChoices.isEmpty;

  PlaybackState copyWith({
    String? currentNodeId,
    List<String>? visitedNodes,
    Map<String, bool>? flagMap,
  }) {
    return PlaybackState(
      nodes: nodes,
      choices: choices,
      requirementFlags: requirementFlags,
      rewardFlags: rewardFlags,
      currentNodeId: currentNodeId ?? this.currentNodeId,
      visitedNodes: visitedNodes ?? this.visitedNodes,
      flagMap: flagMap ?? this.flagMap,
    );
  }
}

@riverpod
class Playback extends _$Playback {
  @override
  Future<PlaybackState> build(String npcId) async {
    final graph = await ref.read(dialogueGraphProvider(npcId).future);

    final choiceIds = graph.choices.map((c) => c.id).toList();
    final nodeIds = graph.nodes.map((n) => n.id).toList();

    final reqFlags = await ref
        .read(requirementFlagRepositoryProvider)
        .getByChoiceIds(choiceIds);
    final rewFlags = await ref
        .read(rewardFlagRepositoryProvider)
        .getByNodeIds(nodeIds);

    final reqFlagsByChoice = <String, List<RequirementFlag>>{};
    for (final f in reqFlags) {
      reqFlagsByChoice.putIfAbsent(f.choiceId, () => []).add(f);
    }

    final rewFlagsByNode = <String, List<RewardFlag>>{};
    for (final f in rewFlags) {
      rewFlagsByNode.putIfAbsent(f.nodeId, () => []).add(f);
    }

    final startNode = graph.nodes.firstWhere(
      (n) => n.isStart,
      orElse: () => graph.nodes.first,
    );

    final initialFlagMap = <String, bool>{};
    for (final rf in rewFlagsByNode[startNode.id] ?? []) {
      initialFlagMap[rf.flagName] = rf.setValue;
    }

    return PlaybackState(
      nodes: graph.nodes,
      choices: graph.choices,
      requirementFlags: reqFlagsByChoice,
      rewardFlags: rewFlagsByNode,
      currentNodeId: startNode.id,
      visitedNodes: const [],
      flagMap: initialFlagMap,
    );
  }

  void chooseOption(String choiceId) {
    final s = state.valueOrNull;
    if (s == null) return;

    if (s.isChoiceLocked(choiceId)) return;

    final choice = s.choices.firstWhere((c) => c.id == choiceId);
    if (choice.toNodeId == null) return;

    final nextNodeId = choice.toNodeId!;
    final newFlagMap = Map<String, bool>.from(s.flagMap);
    for (final rf in s.rewardFlags[nextNodeId] ?? []) {
      newFlagMap[rf.flagName] = rf.setValue;
    }

    state = AsyncData(s.copyWith(
      currentNodeId: nextNodeId,
      visitedNodes: [...s.visitedNodes, s.currentNodeId],
      flagMap: newFlagMap,
    ));
  }

  void back() {
    final s = state.valueOrNull;
    if (s == null || s.visitedNodes.isEmpty) return;

    final previousNodeId = s.visitedNodes.last;
    state = AsyncData(s.copyWith(
      currentNodeId: previousNodeId,
      visitedNodes: s.visitedNodes.sublist(0, s.visitedNodes.length - 1),
    ));
  }

  Future<void> restart() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(npcId));
  }
}
