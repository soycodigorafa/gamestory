import 'package:drift/drift.dart';

@DataClassName('MilestoneRow')
class Milestones extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get label => text()();
  IntColumn get targetCount => integer()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
