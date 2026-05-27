import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers/database_provider.dart';
import '../../../domain/entities/item.dart';
import '../../../domain/entities/item_input.dart';

part 'items_provider.g.dart';

@riverpod
Stream<List<Item>> itemList(Ref ref, String projectId) =>
    ref.watch(itemRepositoryProvider).watchByProject(projectId);

@riverpod
class ItemsNotifier extends _$ItemsNotifier {
  @override
  void build(String projectId) {}

  Future<Item> create(CreateItemInput input) =>
      ref.read(itemRepositoryProvider).create(input);

  Future<void> update(UpdateItemInput input) =>
      ref.read(itemRepositoryProvider).update(input);

  Future<void> delete(String id) =>
      ref.read(itemRepositoryProvider).delete(id);
}
