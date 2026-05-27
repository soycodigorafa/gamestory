import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/node_conditions_table.dart';
import '../tables/node_item_unlocks_table.dart';

part 'node_link_dao.g.dart';

@DriftAccessor(tables: [NodeItemUnlocks, NodeConditions])
class NodeLinkDao extends DatabaseAccessor<AppDatabase>
    with _$NodeLinkDaoMixin {
  NodeLinkDao(super.db);

  Stream<List<NodeItemUnlock>> watchItemUnlocksForProject(
    List<String> nodeIds,
  ) =>
      (select(nodeItemUnlocks)
            ..where((t) => t.nodeId.isIn(nodeIds)))
          .watch();

  Future<void> insertItemUnlock(NodeItemUnlocksCompanion companion) =>
      into(nodeItemUnlocks).insert(companion);

  Future<int> deleteItemUnlock(String nodeId, String itemId) =>
      (delete(nodeItemUnlocks)
            ..where(
              (t) => t.nodeId.equals(nodeId) & t.itemId.equals(itemId),
            ))
          .go();

  Future<int> deleteItemUnlocksByNode(String nodeId) =>
      (delete(nodeItemUnlocks)..where((t) => t.nodeId.equals(nodeId))).go();

  Stream<List<NodeCondition>> watchNodeConditionsForProject(
    List<String> nodeIds,
  ) =>
      (select(nodeConditions)
            ..where((t) => t.nodeId.isIn(nodeIds)))
          .watch();

  Future<void> insertNodeCondition(NodeConditionsCompanion companion) =>
      into(nodeConditions).insert(companion);

  Future<int> deleteNodeCondition(String nodeId, String conditionId) =>
      (delete(nodeConditions)
            ..where(
              (t) =>
                  t.nodeId.equals(nodeId) &
                  t.conditionId.equals(conditionId),
            ))
          .go();

  Future<int> deleteNodeConditionsByNode(String nodeId) =>
      (delete(nodeConditions)..where((t) => t.nodeId.equals(nodeId))).go();
}
