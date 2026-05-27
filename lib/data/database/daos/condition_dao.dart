import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/conditions_table.dart';

part 'condition_dao.g.dart';

@DriftAccessor(tables: [Conditions])
class ConditionDao extends DatabaseAccessor<AppDatabase>
    with _$ConditionDaoMixin {
  ConditionDao(super.db);

  Stream<List<ConditionRow>> watchByProject(String projectId) =>
      (select(conditions)..where((t) => t.projectId.equals(projectId)))
          .watch();

  Future<void> insertCondition(ConditionsCompanion companion) =>
      into(conditions).insert(companion);

  Future<bool> updateCondition(ConditionsCompanion companion) =>
      update(conditions).replace(companion);

  Future<int> deleteCondition(String id) =>
      (delete(conditions)..where((t) => t.id.equals(id))).go();
}
