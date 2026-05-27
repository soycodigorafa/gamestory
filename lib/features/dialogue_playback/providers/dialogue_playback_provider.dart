import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/condition.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../domain/entities/playback_state.dart';
import '../../conditions/providers/conditions_provider.dart';
import '../../dialogue_tree/providers/dialogue_tree_provider.dart';

part 'dialogue_playback_provider.g.dart';

@riverpod
class DialoguePlayback extends _$DialoguePlayback {
  late List<DialogueNode> _allNodes;
  late List<Condition> _allConditions;
  late String _startNodeId;

  @override
  Future<PlaybackState> build(String projectId, String startNodeId) async {
    _allNodes =
        await ref.watch(dialogueTreeProvider(projectId).future);
    _allConditions =
        await ref.watch(conditionListProvider(projectId).future);
    _startNodeId = startNodeId;

    final startNode = _allNodes.firstWhere((n) => n.id == startNodeId);
    final flagValues = {
      for (final c in _allConditions)
        if (c.conditionType == ConditionType.flag) c.id: false,
    };

    return PlaybackState(
      currentNode: startNode,
      history: const [],
      visitedNodeIds: {startNodeId},
      unlockedItemIds: Set.unmodifiable(startNode.unlockedItemIds),
      flagValues: Map.unmodifiable(flagValues),
    );
  }

  List<DialogueNode> childrenOf(String nodeId) =>
      _allNodes.where((n) => n.parentId == nodeId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  bool isDeadEnd(String nodeId) => !_allNodes.any((n) => n.parentId == nodeId);

  /// Returns true when at least one condition on [node] is not met.
  bool isNodeGated(DialogueNode node) {
    if (node.conditionIds.isEmpty) return false;
    final ps = state.valueOrNull;
    if (ps == null) return false;
    for (final condId in node.conditionIds) {
      final met = ps.flagValues[condId] ?? false;
      if (!met) return true;
    }
    return false;
  }

  void chooseNode(DialogueNode node) {
    final ps = state.valueOrNull;
    if (ps == null) return;
    final newHistory = [...ps.history, ps.currentNode];
    final newVisited = {...ps.visitedNodeIds, node.id};
    final newUnlocked = {...ps.unlockedItemIds, ...node.unlockedItemIds};

    state = AsyncData(
      ps.copyWith(
        currentNode: node,
        history: newHistory,
        visitedNodeIds: newVisited,
        unlockedItemIds: newUnlocked,
      ),
    );
  }

  void goBack() {
    final ps = state.valueOrNull;
    if (ps == null || !ps.canGoBack) return;
    final prev = ps.history.last;
    final newHistory = List<DialogueNode>.from(ps.history)..removeLast();

    state = AsyncData(
      ps.copyWith(
        currentNode: prev,
        history: newHistory,
      ),
    );
  }

  void restart() {
    final ps = state.valueOrNull;
    if (ps == null) return;
    final startNode = _allNodes.firstWhere((n) => n.id == _startNodeId);
    final flagValues = {
      for (final c in _allConditions)
        if (c.conditionType == ConditionType.flag) c.id: false,
    };

    state = AsyncData(
      ps.copyWith(
        currentNode: startNode,
        history: const [],
        visitedNodeIds: {_startNodeId},
        unlockedItemIds: Set.unmodifiable(startNode.unlockedItemIds),
        flagValues: Map.unmodifiable(flagValues),
      ),
    );
  }
}
