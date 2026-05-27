import 'package:drift/drift.dart';

@DataClassName('DialogueNodeRow')
class DialogueNodes extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get speakerName => text()();
  TextColumn get dialogueText => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
