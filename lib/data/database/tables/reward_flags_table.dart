import 'package:drift/drift.dart';

class RewardFlagsTable extends Table {
  @override
  String get tableName => 'reward_flags';

  TextColumn get id => text()();
  TextColumn get projectId => text().withDefault(const Constant(''))();
  TextColumn get nodeId => text()();
  TextColumn get flagName => text()();
  BoolColumn get setValue => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
