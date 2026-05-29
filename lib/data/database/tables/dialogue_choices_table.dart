import 'package:drift/drift.dart';

class DialogueChoicesTable extends Table {
  @override
  String get tableName => 'dialogue_choices';

  TextColumn get id => text()();
  TextColumn get projectId => text().withDefault(const Constant(''))();
  TextColumn get fromNodeId => text()();
  TextColumn get toNodeId => text().nullable()();
  TextColumn get choiceText => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
