import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/dialogue_choice.dart';
import '../../domain/repositories/dialogue_choice_repository.dart';
import '../database/app_database.dart';

class DriftDialogueChoiceRepository implements DialogueChoiceRepository {
  DriftDialogueChoiceRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Stream<List<DialogueChoice>> watchByNode(String fromNodeId) {
    return _db.dialogueChoiceDao
        .watchByNode(fromNodeId)
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  @override
  Stream<List<DialogueChoice>> watchAllByNpcId(String npcId) {
    return _db.dialogueChoiceDao
        .watchAllByNpcId(npcId)
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  @override
  Future<DialogueChoice> create(CreateChoiceInput input) async {
    final id = _uuid.v4();
    final companion = DialogueChoicesTableCompanion.insert(
      id: id,
      fromNodeId: input.fromNodeId,
      toNodeId: Value(input.toNodeId),
      choiceText: Value(input.choiceText),
      sortOrder: Value(input.sortOrder),
    );
    await _db.dialogueChoiceDao.upsert(companion);
    return DialogueChoice(
      id: id,
      fromNodeId: input.fromNodeId,
      toNodeId: input.toNodeId,
      choiceText: input.choiceText,
      sortOrder: input.sortOrder,
    );
  }

  @override
  Future<void> update(UpdateChoiceInput input) async {
    final companion = DialogueChoicesTableCompanion(
      id: Value(input.id),
      toNodeId: input.clearToNodeId
          ? const Value(null)
          : input.toNodeId != null
              ? Value(input.toNodeId)
              : const Value.absent(),
      choiceText: input.choiceText != null
          ? Value(input.choiceText!)
          : const Value.absent(),
      sortOrder: input.sortOrder != null
          ? Value(input.sortOrder!)
          : const Value.absent(),
    );
    await _db.dialogueChoiceDao.updateById(companion);
  }

  @override
  Future<void> delete(String id) => _db.dialogueChoiceDao.deleteById(id);

  DialogueChoice _rowToEntity(DialogueChoicesTableData row) {
    return DialogueChoice(
      id: row.id,
      fromNodeId: row.fromNodeId,
      toNodeId: row.toNodeId,
      choiceText: row.choiceText,
      sortOrder: row.sortOrder,
    );
  }
}
