import 'dialogue_node.dart';

class PlaybackState {
  const PlaybackState({
    required this.currentNode,
    required this.history,
    required this.visitedNodeIds,
    required this.unlockedItemIds,
    required this.flagValues,
  });

  final DialogueNode currentNode;
  final List<DialogueNode> history;
  final Set<String> visitedNodeIds;
  final Set<String> unlockedItemIds;

  /// Stub condition flag values: conditionId → met/not-met.
  final Map<String, bool> flagValues;

  bool get canGoBack => history.isNotEmpty;

  PlaybackState copyWith({
    DialogueNode? currentNode,
    List<DialogueNode>? history,
    Set<String>? visitedNodeIds,
    Set<String>? unlockedItemIds,
    Map<String, bool>? flagValues,
  }) {
    return PlaybackState(
      currentNode: currentNode ?? this.currentNode,
      history: history ?? this.history,
      visitedNodeIds: visitedNodeIds ?? this.visitedNodeIds,
      unlockedItemIds: unlockedItemIds ?? this.unlockedItemIds,
      flagValues: flagValues ?? this.flagValues,
    );
  }
}
