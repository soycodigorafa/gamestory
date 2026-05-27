import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/dialogue_nodes_table.dart';

part 'dialogue_node_dao.g.dart';

@DriftAccessor(tables: [DialogueNodesTable])
class DialogueNodeDao extends DatabaseAccessor<AppDatabase>
    with _$DialogueNodeDaoMixin {
  DialogueNodeDao(super.db);

  Stream<List<DialogueNodesTableData>> watchByNpc(String npcId) =>
      (select(dialogueNodesTable)..where((t) => t.npcId.equals(npcId))).watch();

  Future<DialogueNodesTableData?> findById(String id) =>
      (select(dialogueNodesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(DialogueNodesTableCompanion companion) =>
      into(dialogueNodesTable).insertOnConflictUpdate(companion);

  Future<void> updateById(DialogueNodesTableCompanion companion) =>
      (update(dialogueNodesTable)..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  Future<void> clearStartForNpc(String npcId) =>
      (update(dialogueNodesTable)..where((t) => t.npcId.equals(npcId)))
          .write(const DialogueNodesTableCompanion(isStart: Value(false)));

  Future<void> deleteById(String id) =>
      (delete(dialogueNodesTable)..where((t) => t.id.equals(id))).go();
}
