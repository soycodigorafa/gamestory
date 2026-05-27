import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/dialogue_node.dart';
import '../../domain/entities/dialogue_node_input.dart';
import '../../domain/repositories/dialogue_node_repository.dart';
import '../database/app_database.dart';
import '../database/daos/dialogue_node_dao.dart';
import '../database/daos/node_link_dao.dart';
import '../database/tables/dialogue_nodes_table.dart';
import '../database/tables/node_conditions_table.dart';
import '../database/tables/node_item_unlocks_table.dart';

class DriftDialogueNodeRepository implements DialogueNodeRepository {
  DriftDialogueNodeRepository(AppDatabase db)
      : _nodeDao = DialogueNodeDao(db),
        _linkDao = NodeLinkDao(db);

  final DialogueNodeDao _nodeDao;
  final NodeLinkDao _linkDao;
  final _uuid = const Uuid();

  @override
  Stream<List<DialogueNode>> watchByProject(String projectId) =>
      _nodeDao.watchByProject(projectId).map(
            (items) => items
                .map(
                  (nl) => DialogueNode(
                    id: nl.node.id,
                    projectId: nl.node.projectId,
                    parentId: nl.node.parentId,
                    speakerName: nl.node.speakerName,
                    dialogueText: nl.node.dialogueText,
                    sortOrder: nl.node.sortOrder,
                    unlockedItemIds: nl.itemIds,
                    conditionIds: nl.conditionIds,
                  ),
                )
                .toList(),
          );

  @override
  Future<DialogueNode> create(CreateNodeInput input) async {
    final id = _uuid.v4();
    await _nodeDao.insertNode(
      DialogueNodesCompanion.insert(
        id: id,
        projectId: input.projectId,
        parentId: Value(input.parentId),
        speakerName: input.speakerName,
        dialogueText: input.dialogueText,
        sortOrder: Value(input.sortOrder),
      ),
    );
    return DialogueNode(
      id: id,
      projectId: input.projectId,
      parentId: input.parentId,
      speakerName: input.speakerName,
      dialogueText: input.dialogueText,
      sortOrder: input.sortOrder,
    );
  }

  @override
  Future<void> update(UpdateNodeInput input) async {
    await _nodeDao.updateNode(
      DialogueNodesCompanion(
        id: Value(input.id),
        speakerName: input.speakerName != null
            ? Value(input.speakerName!)
            : const Value.absent(),
        dialogueText: input.dialogueText != null
            ? Value(input.dialogueText!)
            : const Value.absent(),
        sortOrder: input.sortOrder != null
            ? Value(input.sortOrder!)
            : const Value.absent(),
      ),
    );
  }

  @override
  Future<void> move(
    String nodeId, {
    String? newParentId,
    required int newSortOrder,
  }) async {
    await _nodeDao.updateNode(
      DialogueNodesCompanion(
        id: Value(nodeId),
        parentId: Value(newParentId),
        sortOrder: Value(newSortOrder),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await _linkDao.deleteItemUnlocksByNode(id);
    await _linkDao.deleteNodeConditionsByNode(id);
    await _nodeDao.deleteNode(id);
  }

  @override
  Future<void> addItemUnlock(String nodeId, String itemId) =>
      _linkDao.insertItemUnlock(
        NodeItemUnlocksCompanion.insert(nodeId: nodeId, itemId: itemId),
      );

  @override
  Future<void> removeItemUnlock(String nodeId, String itemId) =>
      _linkDao.deleteItemUnlock(nodeId, itemId);

  @override
  Future<void> addCondition(String nodeId, String conditionId) =>
      _linkDao.insertNodeCondition(
        NodeConditionsCompanion.insert(
          nodeId: nodeId,
          conditionId: conditionId,
        ),
      );

  @override
  Future<void> removeCondition(String nodeId, String conditionId) =>
      _linkDao.deleteNodeCondition(nodeId, conditionId);
}
