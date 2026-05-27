import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/npc.dart';
import '../../domain/repositories/npc_repository.dart';
import '../database/app_database.dart';

class DriftNpcRepository implements NpcRepository {
  DriftNpcRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Stream<List<Npc>> watchAll() {
    return _db.npcDao.watchAll().map(
          (rows) => rows.map(_rowToEntity).toList(),
        );
  }

  @override
  Future<Npc> create(CreateNpcInput input) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    final companion = NpcsTableCompanion.insert(
      id: id,
      name: input.name,
      description: Value(input.description),
      canvasX: Value(input.canvasX),
      canvasY: Value(input.canvasY),
      colorHex: Value(input.colorHex),
      createdAt: now,
      updatedAt: now,
    );
    await _db.npcDao.upsert(companion);
    return Npc(
      id: id,
      name: input.name,
      description: input.description,
      canvasX: input.canvasX,
      canvasY: input.canvasY,
      colorHex: input.colorHex,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> update(UpdateNpcInput input) async {
    final existing = await _db.npcDao.findById(input.id);
    if (existing == null) return;

    final companion = NpcsTableCompanion(
      id: Value(input.id),
      name: input.name != null ? Value(input.name!) : const Value.absent(),
      description: input.description != null
          ? Value(input.description!)
          : const Value.absent(),
      canvasX:
          input.canvasX != null ? Value(input.canvasX!) : const Value.absent(),
      canvasY:
          input.canvasY != null ? Value(input.canvasY!) : const Value.absent(),
      colorHex: input.colorHex != null
          ? Value(input.colorHex!)
          : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    await _db.npcDao.updateById(companion);
  }

  @override
  Future<void> delete(String id) => _db.npcDao.deleteById(id);

  Npc _rowToEntity(NpcsTableData row) {
    return Npc(
      id: row.id,
      name: row.name,
      description: row.description,
      canvasX: row.canvasX,
      canvasY: row.canvasY,
      colorHex: row.colorHex,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
