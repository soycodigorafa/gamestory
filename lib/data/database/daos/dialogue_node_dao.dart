import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/dialogue_nodes_table.dart';
import '../tables/node_conditions_table.dart';
import '../tables/node_item_unlocks_table.dart';

part 'dialogue_node_dao.g.dart';

class NodeWithLinks {
  const NodeWithLinks({
    required this.node,
    required this.itemIds,
    required this.conditionIds,
  });

  final DialogueNodeRow node;
  final List<String> itemIds;
  final List<String> conditionIds;
}

@DriftAccessor(tables: [DialogueNodes, NodeItemUnlocks, NodeConditions])
class DialogueNodeDao extends DatabaseAccessor<AppDatabase>
    with _$DialogueNodeDaoMixin {
  DialogueNodeDao(super.db);

  Stream<List<NodeWithLinks>> watchByProject(String projectId) {
    const sql = '''
      SELECT
        n.id, n.project_id, n.parent_id, n.speaker_name,
        n.dialogue_text, n.sort_order,
        GROUP_CONCAT(DISTINCT u.item_id) AS item_ids,
        GROUP_CONCAT(DISTINCT c.condition_id) AS condition_ids
      FROM dialogue_nodes n
      LEFT JOIN node_item_unlocks u ON u.node_id = n.id
      LEFT JOIN node_conditions c ON c.node_id = n.id
      WHERE n.project_id = ?
      GROUP BY n.id
      ORDER BY n.sort_order
    ''';
    return customSelect(
      sql,
      variables: [Variable.withString(projectId)],
      readsFrom: {dialogueNodes, nodeItemUnlocks, nodeConditions},
    ).watch().map(
          (rows) => rows.map((row) {
            final rawItemIds = row.read<String?>('item_ids');
            final rawCondIds = row.read<String?>('condition_ids');
            return NodeWithLinks(
              node: DialogueNodeRow(
                id: row.read<String>('id'),
                projectId: row.read<String>('project_id'),
                parentId: row.read<String?>('parent_id'),
                speakerName: row.read<String>('speaker_name'),
                dialogueText: row.read<String>('dialogue_text'),
                sortOrder: row.read<int>('sort_order'),
              ),
              itemIds: rawItemIds != null && rawItemIds.isNotEmpty
                  ? rawItemIds.split(',')
                  : [],
              conditionIds: rawCondIds != null && rawCondIds.isNotEmpty
                  ? rawCondIds.split(',')
                  : [],
            );
          }).toList(),
        );
  }

  Future<void> insertNode(DialogueNodesCompanion companion) =>
      into(dialogueNodes).insert(companion);

  Future<bool> updateNode(DialogueNodesCompanion companion) =>
      update(dialogueNodes).replace(companion);

  Future<int> deleteNode(String id) =>
      (delete(dialogueNodes)..where((t) => t.id.equals(id))).go();
}
