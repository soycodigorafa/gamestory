import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/dialogue_node.dart';
import '../../domain/repositories/dialogue_node_repository.dart';
import '../database/app_database.dart';

class DriftDialogueNodeRepository implements DialogueNodeRepository {
  DriftDialogueNodeRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Stream<List<DialogueNode>> watchByNpc(String npcId) {
    return _db.dialogueNodeDao
        .watchByNpc(npcId)
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  @override
  Future<DialogueNode> create(CreateNodeInput input) async {
    final id = _uuid.v4();
    final companion = DialogueNodesTableCompanion.insert(
      id: id,
      npcId: input.npcId,
      speakerName: Value(input.speakerName),
      dialogueText: Value(input.dialogueText),
      isStart: Value(input.isStart),
      layoutX: Value(input.layoutX),
      layoutY: Value(input.layoutY),
    );
    await _db.dialogueNodeDao.upsert(companion);
    return DialogueNode(
      id: id,
      npcId: input.npcId,
      speakerName: input.speakerName,
      dialogueText: input.dialogueText,
      isStart: input.isStart,
      layoutX: input.layoutX,
      layoutY: input.layoutY,
    );
  }

  @override
  Future<void> update(UpdateNodeInput input) async {
    final existing = await _db.dialogueNodeDao.findById(input.id);
    if (existing == null) return;

    final companion = DialogueNodesTableCompanion(
      id: Value(input.id),
      speakerName: input.speakerName != null
          ? Value(input.speakerName!)
          : const Value.absent(),
      dialogueText: input.dialogueText != null
          ? Value(input.dialogueText!)
          : const Value.absent(),
      isStart: input.isStart != null
          ? Value(input.isStart!)
          : const Value.absent(),
      layoutX: input.layoutX != null
          ? Value(input.layoutX!)
          : const Value.absent(),
      layoutY: input.layoutY != null
          ? Value(input.layoutY!)
          : const Value.absent(),
    );
    await _db.dialogueNodeDao.updateById(companion);
  }

  @override
  Future<void> setStart(String nodeId) async {
    final existing = await _db.dialogueNodeDao.findById(nodeId);
    if (existing == null) return;

    await _db.dialogueNodeDao.clearStartForNpc(existing.npcId);
    await _db.dialogueNodeDao.updateById(
      DialogueNodesTableCompanion(
        id: Value(nodeId),
        isStart: const Value(true),
      ),
    );
  }

  @override
  Future<void> delete(String id) => _db.dialogueNodeDao.deleteById(id);

  DialogueNode _rowToEntity(DialogueNodesTableData row) {
    return DialogueNode(
      id: row.id,
      npcId: row.npcId,
      speakerName: row.speakerName,
      dialogueText: row.dialogueText,
      isStart: row.isStart,
      layoutX: row.layoutX,
      layoutY: row.layoutY,
    );
  }
}
