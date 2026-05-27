import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/reward_flags_table.dart';

part 'reward_flag_dao.g.dart';

@DriftAccessor(tables: [RewardFlagsTable])
class RewardFlagDao extends DatabaseAccessor<AppDatabase>
    with _$RewardFlagDaoMixin {
  RewardFlagDao(super.db);

  Stream<List<RewardFlagsTableData>> watchByNode(String nodeId) =>
      (select(rewardFlagsTable)..where((t) => t.nodeId.equals(nodeId))).watch();

  Future<void> insert(RewardFlagsTableCompanion companion) =>
      into(rewardFlagsTable).insertOnConflictUpdate(companion);

  Future<void> deleteById(String id) =>
      (delete(rewardFlagsTable)..where((t) => t.id.equals(id))).go();

  Future<List<RewardFlagsTableData>> getByNodeIds(List<String> ids) =>
      (select(rewardFlagsTable)..where((t) => t.nodeId.isIn(ids))).get();

  Future<void> deleteByNodeId(String nodeId) =>
      (delete(rewardFlagsTable)..where((t) => t.nodeId.equals(nodeId))).go();
}
