import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/dialogue_choices_table.dart';
import '../tables/dialogue_nodes_table.dart';

part 'dialogue_choice_dao.g.dart';

@DriftAccessor(tables: [DialogueChoicesTable, DialogueNodesTable])
class DialogueChoiceDao extends DatabaseAccessor<AppDatabase>
    with _$DialogueChoiceDaoMixin {
  DialogueChoiceDao(super.db);

  Stream<List<DialogueChoicesTableData>> watchByNode(String fromNodeId) =>
      (select(dialogueChoicesTable)
            ..where((t) => t.fromNodeId.equals(fromNodeId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Stream<List<DialogueChoicesTableData>> watchAllByNpcId(String npcId) {
    final query = select(dialogueChoicesTable).join([
      innerJoin(
        dialogueNodesTable,
        dialogueNodesTable.id.equalsExp(dialogueChoicesTable.fromNodeId),
      ),
    ])..where(dialogueNodesTable.npcId.equals(npcId));

    return query.watch().map(
          (rows) =>
              rows.map((row) => row.readTable(dialogueChoicesTable)).toList(),
        );
  }

  Future<void> upsert(DialogueChoicesTableCompanion companion) =>
      into(dialogueChoicesTable).insertOnConflictUpdate(companion);

  Future<void> updateById(DialogueChoicesTableCompanion companion) =>
      (update(dialogueChoicesTable)
            ..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  Future<void> deleteById(String id) =>
      (delete(dialogueChoicesTable)..where((t) => t.id.equals(id))).go();
}
