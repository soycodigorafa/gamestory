import 'package:drift/drift.dart';

class NodeItemUnlocks extends Table {
  TextColumn get nodeId => text()();
  TextColumn get itemId => text()();

  @override
  Set<Column> get primaryKey => {nodeId, itemId};
}
