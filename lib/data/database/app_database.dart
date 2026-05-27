import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/dialogue_choice_dao.dart';
import 'daos/dialogue_node_dao.dart';
import 'daos/npc_dao.dart';
import 'daos/requirement_flag_dao.dart';
import 'daos/reward_flag_dao.dart';
import 'tables/dialogue_choices_table.dart';
import 'tables/dialogue_nodes_table.dart';
import 'tables/npcs_table.dart';
import 'tables/requirement_flags_table.dart';
import 'tables/reward_flags_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [NpcsTable, DialogueNodesTable, DialogueChoicesTable, RequirementFlagsTable, RewardFlagsTable],
  daos: [NpcDao, DialogueNodeDao, DialogueChoiceDao, RequirementFlagDao, RewardFlagDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
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
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'gamestory');
  }
}
