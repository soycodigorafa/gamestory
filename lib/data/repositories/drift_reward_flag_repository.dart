import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/reward_flag.dart';
import '../../domain/repositories/reward_flag_repository.dart';
import '../database/app_database.dart';
import '../database/daos/reward_flag_dao.dart';

class DriftRewardFlagRepository implements RewardFlagRepository {
  DriftRewardFlagRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  RewardFlagDao get _dao => _db.rewardFlagDao;

  @override
  Future<List<RewardFlag>> getByNodeIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final rows = await _dao.getByNodeIds(ids);
    return rows.map(_rowToEntity).toList();
  }

  @override
  Stream<List<RewardFlag>> watchByNode(String nodeId) {
    return _dao
        .watchByNode(nodeId)
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  @override
  Future<RewardFlag> create(CreateRewardFlagInput input) async {
    final id = _uuid.v4();
    final companion = RewardFlagsTableCompanion.insert(
      id: id,
      nodeId: input.nodeId,
      flagName: input.flagName,
      setValue: Value(input.setValue),
    );
    await _dao.insert(companion);
    return RewardFlag(
      id: id,
      nodeId: input.nodeId,
      flagName: input.flagName,
      setValue: input.setValue,
    );
  }

  @override
  Future<void> delete(String id) => _dao.deleteById(id);

  @override
  Future<void> deleteByNodeId(String nodeId) => _dao.deleteByNodeId(nodeId);

  RewardFlag _rowToEntity(RewardFlagsTableData row) {
    return RewardFlag(
      id: row.id,
      nodeId: row.nodeId,
      flagName: row.flagName,
      setValue: row.setValue,
    );
  }
}
