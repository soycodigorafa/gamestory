import 'package:drift/drift.dart';

class NpcsTable extends Table {
  @override
  String get tableName => 'npcs';

  TextColumn get id => text()();
  TextColumn get projectId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get canvasX => real().withDefault(const Constant(0.0))();
  RealColumn get canvasY => real().withDefault(const Constant(0.0))();
  TextColumn get colorHex =>
      text().withDefault(const Constant('#7B61FF'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
