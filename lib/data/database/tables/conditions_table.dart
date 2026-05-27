import 'package:drift/drift.dart';

@DataClassName('ConditionRow')
class Conditions extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get expression => text()();
  TextColumn get conditionType => text()();

  @override
  Set<Column> get primaryKey => {id};
}
