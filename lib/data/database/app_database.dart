import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/dialogue_choice_dao.dart';
import 'daos/dialogue_node_dao.dart';
import 'daos/npc_dao.dart';
import 'tables/dialogue_choices_table.dart';
import 'tables/dialogue_nodes_table.dart';
import 'tables/npcs_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [NpcsTable, DialogueNodesTable, DialogueChoicesTable],
  daos: [NpcDao, DialogueNodeDao, DialogueChoiceDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

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
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'gamestory');
  }
}
