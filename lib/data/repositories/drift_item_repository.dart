import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/item.dart';
import '../../domain/entities/item_input.dart';
import '../../domain/repositories/item_repository.dart';
import '../database/app_database.dart';
import '../database/daos/item_dao.dart';
import '../database/tables/items_table.dart';

class DriftItemRepository implements ItemRepository {
  DriftItemRepository(AppDatabase db) : _dao = ItemDao(db);

  final ItemDao _dao;
  final _uuid = const Uuid();

  @override
  Stream<List<Item>> watchByProject(String projectId) =>
      _dao.watchByProject(projectId).map(
            (rows) => rows.map(_toEntity).toList(),
          );

  @override
  Future<Item> create(CreateItemInput input) async {
    final id = _uuid.v4();
    await _dao.insertItem(
      ItemsCompanion.insert(
        id: id,
        projectId: input.projectId,
        name: input.name,
        description: Value(input.description),
      ),
    );
    return Item(
      id: id,
      projectId: input.projectId,
      name: input.name,
      description: input.description,
    );
  }

  @override
  Future<void> update(UpdateItemInput input) async {
    await _dao.updateItem(
      ItemsCompanion(
        id: Value(input.id),
        name: input.name != null ? Value(input.name!) : const Value.absent(),
        description: input.description != null
            ? Value(input.description!)
            : const Value.absent(),
      ),
    );
  }

  @override
  Future<void> delete(String id) => _dao.deleteItem(id);

  Item _toEntity(ItemRow row) => Item(
        id: row.id,
        projectId: row.projectId,
        name: row.name,
        description: row.description,
      );
}
