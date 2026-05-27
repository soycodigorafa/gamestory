import '../entities/item.dart';
import '../entities/item_input.dart';

abstract interface class ItemRepository {
  Stream<List<Item>> watchByProject(String projectId);
  Future<Item> create(CreateItemInput input);
  Future<void> update(UpdateItemInput input);
  Future<void> delete(String id);
}
