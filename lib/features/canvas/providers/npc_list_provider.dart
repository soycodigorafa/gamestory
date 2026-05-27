import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/drift_npc_repository.dart';
import '../../../domain/entities/npc.dart';
import '../../../domain/repositories/npc_repository.dart';

part 'npc_list_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
NpcRepository npcRepository(NpcRepositoryRef ref) {
  return DriftNpcRepository(ref.watch(appDatabaseProvider));
}

@riverpod
class NpcList extends _$NpcList {
  @override
  Stream<List<Npc>> build() {
    return ref.watch(npcRepositoryProvider).watchAll();
  }

  Future<void> createNpc(String name, {String description = ''}) {
    return ref.read(npcRepositoryProvider).create(
          CreateNpcInput(name: name, description: description),
        );
  }

  Future<void> renameNpc(String id, String name) {
    return ref.read(npcRepositoryProvider).update(
          UpdateNpcInput(id: id, name: name),
        );
  }

  Future<void> moveNpc(String id, double x, double y) {
    return ref.read(npcRepositoryProvider).update(
          UpdateNpcInput(id: id, canvasX: x, canvasY: y),
        );
  }

  Future<void> deleteNpc(String id) {
    return ref.read(npcRepositoryProvider).delete(id);
  }
}
