import 'package:drift/drift.dart';

class DialogueNodesTable extends Table {
  @override
  String get tableName => 'dialogue_nodes';

  TextColumn get id => text()();
  TextColumn get npcId => text()();
  TextColumn get speakerName => text().withDefault(const Constant(''))();
  TextColumn get dialogueText => text().withDefault(const Constant(''))();
  BoolColumn get isStart => boolean().withDefault(const Constant(false))();
  RealColumn get layoutX => real().withDefault(const Constant(0.0))();
  RealColumn get layoutY => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}
