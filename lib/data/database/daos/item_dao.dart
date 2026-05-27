import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/items_table.dart';

part 'item_dao.g.dart';

@DriftAccessor(tables: [Items])
class ItemDao extends DatabaseAccessor<AppDatabase> with _$ItemDaoMixin {
  ItemDao(super.db);

  Stream<List<ItemRow>> watchByProject(String projectId) =>
      (select(items)..where((t) => t.projectId.equals(projectId))).watch();

  Future<void> insertItem(ItemsCompanion companion) =>
      into(items).insert(companion);

  Future<bool> updateItem(ItemsCompanion companion) =>
      update(items).replace(companion);

  Future<int> deleteItem(String id) =>
      (delete(items)..where((t) => t.id.equals(id))).go();
}
