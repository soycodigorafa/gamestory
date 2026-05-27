import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/dialogue_nodes_table.dart';
import '../tables/milestones_table.dart';
import '../tables/node_conditions_table.dart';
import '../tables/node_item_unlocks_table.dart';

part 'milestone_dao.g.dart';

@DriftAccessor(
  tables: [Milestones, DialogueNodes, NodeItemUnlocks, NodeConditions],
)
class MilestoneDao extends DatabaseAccessor<AppDatabase>
    with _$MilestoneDaoMixin {
  MilestoneDao(super.db);

  Stream<List<MilestoneRow>> watchByProject(String projectId) =>
      (select(milestones)..where((t) => t.projectId.equals(projectId)))
          .watch();

  Future<void> insertMilestone(MilestonesCompanion companion) =>
      into(milestones).insert(companion);

  Future<bool> updateMilestone(MilestonesCompanion companion) =>
      update(milestones).replace(companion);

  Future<int> deleteMilestone(String id) =>
      (delete(milestones)..where((t) => t.id.equals(id))).go();

  Stream<double> watchProgress(String projectId) {
    const sql = '''
      SELECT COALESCE(
        CAST(SUM(CASE
          WHEN EXISTS(
            SELECT 1 FROM node_item_unlocks WHERE node_id = n.id
          ) OR EXISTS(
            SELECT 1 FROM node_conditions WHERE node_id = n.id
          ) THEN 1 ELSE 0 END
        ) AS REAL) / NULLIF(CAST(COUNT(*) AS REAL), 0)
      , 0.0) AS progress
      FROM dialogue_nodes n
      WHERE n.project_id = ?
    ''';
    return customSelect(
      sql,
      variables: [Variable.withString(projectId)],
      readsFrom: {dialogueNodes, nodeItemUnlocks, nodeConditions},
    ).watchSingle().map((row) => row.read<double>('progress'));
  }
}
