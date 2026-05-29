import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/dialogue_choice_dao.dart';
import 'daos/dialogue_node_dao.dart';
import 'daos/npc_dao.dart';
import 'daos/project_dao.dart';
import 'daos/requirement_flag_dao.dart';
import 'daos/reward_flag_dao.dart';
import 'tables/dialogue_choices_table.dart';
import 'tables/dialogue_nodes_table.dart';
import 'tables/npcs_table.dart';
import 'tables/projects_table.dart';
import 'tables/requirement_flags_table.dart';
import 'tables/reward_flags_table.dart';

part 'app_database.g.dart';

const kDefaultProjectId = '00000000-0000-0000-0000-000000000001';

@DriftDatabase(
  tables: [
    ProjectsTable,
    NpcsTable,
    DialogueNodesTable,
    DialogueChoicesTable,
    RequirementFlagsTable,
    RewardFlagsTable,
  ],
  daos: [ProjectDao, NpcDao, DialogueNodeDao, DialogueChoiceDao, RequirementFlagDao, RewardFlagDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultProject();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(dialogueNodesTable);
            await m.createTable(dialogueChoicesTable);
          }
          if (from < 3) {
            await m.createTable(requirementFlagsTable);
          }
          if (from < 4) {
            await m.createTable(rewardFlagsTable);
          }
          if (from < 5) {
            await m.createTable(projectsTable);
            await _seedDefaultProject();
            await m.addColumn(npcsTable, npcsTable.projectId);
            await m.addColumn(dialogueNodesTable, dialogueNodesTable.projectId);
            await m.addColumn(dialogueChoicesTable, dialogueChoicesTable.projectId);
            await m.addColumn(requirementFlagsTable, requirementFlagsTable.projectId);
            await m.addColumn(rewardFlagsTable, rewardFlagsTable.projectId);
            await customStatement(
              'UPDATE npcs SET project_id = ?', [kDefaultProjectId],
            );
            await customStatement(
              'UPDATE dialogue_nodes SET project_id = ?', [kDefaultProjectId],
            );
            await customStatement(
              'UPDATE dialogue_choices SET project_id = ?', [kDefaultProjectId],
            );
            await customStatement(
              'UPDATE requirement_flags SET project_id = ?', [kDefaultProjectId],
            );
            await customStatement(
              'UPDATE reward_flags SET project_id = ?', [kDefaultProjectId],
            );
          }
        },
      );

  Future<void> _seedDefaultProject() async {
    final now = DateTime.now();
    await into(projectsTable).insertOnConflictUpdate(
      ProjectsTableCompanion.insert(
        id: kDefaultProjectId,
        name: 'Default Project',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'gamestory');
  }
}
