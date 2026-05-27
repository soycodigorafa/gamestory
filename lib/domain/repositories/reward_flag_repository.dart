import '../entities/reward_flag.dart';

abstract interface class RewardFlagRepository {
  Stream<List<RewardFlag>> watchByNode(String nodeId);
  Future<List<RewardFlag>> getByNodeIds(List<String> ids);
  Future<RewardFlag> create(CreateRewardFlagInput input);
  Future<void> delete(String id);
  Future<void> deleteByNodeId(String nodeId);
}
