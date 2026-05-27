import 'package:drift/drift.dart';

class NodeConditions extends Table {
  TextColumn get nodeId => text()();
  TextColumn get conditionId => text()();
  TextColumn get requirementType =>
      text().withDefault(const Constant('requires'))();

  @override
  Set<Column> get primaryKey => {nodeId, conditionId};
}
