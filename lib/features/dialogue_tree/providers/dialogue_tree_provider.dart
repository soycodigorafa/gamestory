import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers/database_provider.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../domain/entities/dialogue_node_input.dart';

part 'dialogue_tree_provider.g.dart';

@riverpod
Stream<List<DialogueNode>> dialogueTree(Ref ref, String projectId) =>
    ref.watch(dialogueNodeRepositoryProvider).watchByProject(projectId);

@riverpod
class DialogueTreeNotifier extends _$DialogueTreeNotifier {
  @override
  void build(String projectId) {}

  Future<DialogueNode> addNode(CreateNodeInput input) =>
      ref.read(dialogueNodeRepositoryProvider).create(input);

  Future<void> updateNode(UpdateNodeInput input) =>
      ref.read(dialogueNodeRepositoryProvider).update(input);

  Future<void> moveNode(
    String nodeId, {
    String? newParentId,
    required int newSortOrder,
  }) =>
      ref.read(dialogueNodeRepositoryProvider).move(
            nodeId,
            newParentId: newParentId,
            newSortOrder: newSortOrder,
          );

  Future<void> deleteNode(String id) =>
      ref.read(dialogueNodeRepositoryProvider).delete(id);

  Future<void> addItemUnlock(String nodeId, String itemId) =>
      ref.read(dialogueNodeRepositoryProvider).addItemUnlock(nodeId, itemId);

  Future<void> removeItemUnlock(String nodeId, String itemId) =>
      ref.read(dialogueNodeRepositoryProvider).removeItemUnlock(nodeId, itemId);

  Future<void> addCondition(String nodeId, String conditionId) =>
      ref.read(dialogueNodeRepositoryProvider).addCondition(nodeId, conditionId);

  Future<void> removeCondition(String nodeId, String conditionId) =>
      ref
          .read(dialogueNodeRepositoryProvider)
          .removeCondition(nodeId, conditionId);
}
