import 'package:drift/drift.dart';

class RequirementFlagsTable extends Table {
  @override
  String get tableName => 'requirement_flags';

  TextColumn get id => text()();
  TextColumn get choiceId => text()();
  TextColumn get flagName => text()();
  BoolColumn get requiredValue => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
