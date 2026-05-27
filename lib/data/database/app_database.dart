import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/conditions_table.dart';
import 'tables/dialogue_nodes_table.dart';
import 'tables/items_table.dart';
import 'tables/milestones_table.dart';
import 'tables/node_conditions_table.dart';
import 'tables/node_item_unlocks_table.dart';
import 'tables/projects_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Projects,
    DialogueNodes,
    Items,
    Conditions,
    NodeItemUnlocks,
    NodeConditions,
    Milestones,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'gamestory'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );
}
