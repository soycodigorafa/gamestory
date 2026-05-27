import '../entities/dialogue_node.dart';
import '../entities/dialogue_node_input.dart';

abstract interface class DialogueNodeRepository {
  Stream<List<DialogueNode>> watchByProject(String projectId);
  Future<DialogueNode> create(CreateNodeInput input);
  Future<void> update(UpdateNodeInput input);
  Future<void> move(String nodeId, {String? newParentId, required int newSortOrder});
  Future<void> delete(String id);
  Future<void> addItemUnlock(String nodeId, String itemId);
  Future<void> removeItemUnlock(String nodeId, String itemId);
  Future<void> addCondition(String nodeId, String conditionId);
  Future<void> removeCondition(String nodeId, String conditionId);
}
