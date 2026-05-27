import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/condition.dart';
import '../../domain/entities/condition_input.dart';
import '../../domain/repositories/condition_repository.dart';
import '../database/app_database.dart';
import '../database/daos/condition_dao.dart';
import '../database/tables/conditions_table.dart';

class DriftConditionRepository implements ConditionRepository {
  DriftConditionRepository(AppDatabase db) : _dao = ConditionDao(db);

  final ConditionDao _dao;
  final _uuid = const Uuid();

  @override
  Stream<List<Condition>> watchByProject(String projectId) =>
      _dao.watchByProject(projectId).map(
            (rows) => rows.map(_toEntity).toList(),
          );

  @override
  Future<Condition> create(CreateConditionInput input) async {
    final id = _uuid.v4();
    await _dao.insertCondition(
      ConditionsCompanion.insert(
        id: id,
        projectId: input.projectId,
        expression: input.expression,
        conditionType: _typeToString(input.conditionType),
      ),
    );
    return Condition(
      id: id,
      projectId: input.projectId,
      expression: input.expression,
      conditionType: input.conditionType,
    );
  }

  @override
  Future<void> update(UpdateConditionInput input) async {
    await _dao.updateCondition(
      ConditionsCompanion(
        id: Value(input.id),
        expression: input.expression != null
            ? Value(input.expression!)
            : const Value.absent(),
        conditionType: input.conditionType != null
            ? Value(_typeToString(input.conditionType!))
            : const Value.absent(),
      ),
    );
  }

  @override
  Future<void> delete(String id) => _dao.deleteCondition(id);

  Condition _toEntity(ConditionRow row) => Condition(
        id: row.id,
        projectId: row.projectId,
        expression: row.expression,
        conditionType: _typeFromString(row.conditionType),
      );

  static String _typeToString(ConditionType type) => switch (type) {
        ConditionType.flag => 'flag',
        ConditionType.inventory => 'inventory',
        ConditionType.stat => 'stat',
      };

  static ConditionType _typeFromString(String value) => switch (value) {
        'inventory' => ConditionType.inventory,
        'stat' => ConditionType.stat,
        _ => ConditionType.flag,
      };
}
