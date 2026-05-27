import '../entities/dialogue_node.dart';

abstract interface class DialogueNodeRepository {
  Stream<List<DialogueNode>> watchByNpc(String npcId);
  Future<DialogueNode> create(CreateNodeInput input);
  Future<void> update(UpdateNodeInput input);
  Future<void> setStart(String nodeId);
  Future<void> delete(String id);
}
