import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/condition.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../domain/entities/playback_state.dart';
import '../../../shared/utils/stub_data.dart';

part 'dialogue_playback_provider.g.dart';

// TODO(M4): replace StubData access with injected repository when real data
// layer is wired up.

@riverpod
class DialoguePlayback extends _$DialoguePlayback {
  late List<DialogueNode> _allNodes;
  late List<Condition> _allConditions;
  late String _startNodeId;

  @override
  PlaybackState build(String projectId, String startNodeId) {
    _allNodes = StubData.nodesForProject(projectId);
    _allConditions = StubData.conditionsForProject(projectId);
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
    for (final condId in node.conditionIds) {
      final met = state.flagValues[condId] ?? false;
      if (!met) return true;
    }
    return false;
  }

  void chooseNode(DialogueNode node) {
    final newHistory = [...state.history, state.currentNode];
    final newVisited = {...state.visitedNodeIds, node.id};
    final newUnlocked = {...state.unlockedItemIds, ...node.unlockedItemIds};

    state = state.copyWith(
      currentNode: node,
      history: newHistory,
      visitedNodeIds: newVisited,
      unlockedItemIds: newUnlocked,
    );
  }

  void goBack() {
    if (!state.canGoBack) return;
    final prev = state.history.last;
    final newHistory = List<DialogueNode>.from(state.history)..removeLast();

    state = state.copyWith(
      currentNode: prev,
      history: newHistory,
    );
  }

  void restart() {
    final startNode = _allNodes.firstWhere((n) => n.id == _startNodeId);
    final flagValues = {
      for (final c in _allConditions)
        if (c.conditionType == ConditionType.flag) c.id: false,
    };

    state = state.copyWith(
      currentNode: startNode,
      history: const [],
      visitedNodeIds: {_startNodeId},
      unlockedItemIds: Set.unmodifiable(startNode.unlockedItemIds),
      flagValues: Map.unmodifiable(flagValues),
    );
  }
}
