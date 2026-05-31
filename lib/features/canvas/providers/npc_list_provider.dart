import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/drift_npc_repository.dart';
import '../../../domain/entities/npc.dart';
import '../../../domain/repositories/npc_repository.dart';
import '../../export/providers/project_dirty_provider.dart';
import '../../projects/providers/project_list_provider.dart';

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
    final project = ref.watch(currentProjectProvider);
    if (project == null) return const Stream.empty();
    return ref.watch(npcRepositoryProvider).watchByProject(project.id);
  }

  Future<void> createNpc(
    String name, {
    String description = '',
    double canvasX = 0,
    double canvasY = 0,
  }) async {
    final projectId = ref.read(currentProjectProvider)?.id ?? '';
    await ref.read(npcRepositoryProvider).create(
          CreateNpcInput(
            name: name,
            projectId: projectId,
            description: description,
            canvasX: canvasX,
            canvasY: canvasY,
          ),
        );
    ref.read(projectDirtyProvider.notifier).markDirty();
  }

  Future<void> renameNpc(String id, String name) async {
    await ref.read(npcRepositoryProvider).update(
          UpdateNpcInput(id: id, name: name),
        );
    ref.read(projectDirtyProvider.notifier).markDirty();
  }

  Future<void> moveNpc(String id, double x, double y) async {
    await ref.read(npcRepositoryProvider).update(
          UpdateNpcInput(id: id, canvasX: x, canvasY: y),
        );
    ref.read(projectDirtyProvider.notifier).markDirty();
  }

  Future<void> deleteNpc(String id) async {
    await ref.read(npcRepositoryProvider).delete(id);
    ref.read(projectDirtyProvider.notifier).markDirty();
  }
}
