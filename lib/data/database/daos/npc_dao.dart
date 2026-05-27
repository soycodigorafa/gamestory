import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/npcs_table.dart';

part 'npc_dao.g.dart';

@DriftAccessor(tables: [NpcsTable])
class NpcDao extends DatabaseAccessor<AppDatabase> with _$NpcDaoMixin {
  NpcDao(super.db);

  Stream<List<NpcsTableData>> watchAll() =>
      select(npcsTable).watch();

  Future<NpcsTableData?> findById(String id) =>
      (select(npcsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(NpcsTableCompanion companion) =>
      into(npcsTable).insertOnConflictUpdate(companion);

  Future<void> updateById(NpcsTableCompanion companion) =>
      (update(npcsTable)..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  Future<void> deleteById(String id) =>
      (delete(npcsTable)..where((t) => t.id.equals(id))).go();
}
