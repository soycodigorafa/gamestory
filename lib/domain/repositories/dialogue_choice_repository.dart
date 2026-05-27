import '../entities/dialogue_choice.dart';

abstract interface class DialogueChoiceRepository {
  Stream<List<DialogueChoice>> watchByNode(String fromNodeId);
  Stream<List<DialogueChoice>> watchAllByNpcId(String npcId);
  Future<DialogueChoice> create(CreateChoiceInput input);
  Future<void> update(UpdateChoiceInput input);
  Future<void> delete(String id);
}
