import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/domain/entities/dialogue_choice.dart';
import 'package:gamestory/domain/entities/dialogue_node.dart';
import 'package:gamestory/domain/entities/npc.dart';
import 'package:gamestory/domain/entities/requirement_flag.dart';
import 'package:gamestory/domain/entities/reward_flag.dart';
import 'package:gamestory/domain/repositories/dialogue_choice_repository.dart';
import 'package:gamestory/domain/repositories/dialogue_node_repository.dart';
import 'package:gamestory/domain/repositories/npc_repository.dart';
import 'package:gamestory/domain/repositories/requirement_flag_repository.dart';
import 'package:gamestory/domain/repositories/reward_flag_repository.dart';
import 'package:gamestory/features/export/services/export_service.dart';
import 'package:gamestory/features/export/services/import_service.dart';

class _FakeNpcRepo implements NpcRepository {
  final List<Npc> created = [];

  @override
  Stream<List<Npc>> watchAll() => const Stream.empty();

  @override
  Future<Npc> create(CreateNpcInput input) async {
    final npc = Npc(
      id: 'new-npc-${created.length}',
      name: input.name,
      description: input.description,
      canvasX: input.canvasX,
      canvasY: input.canvasY,
      colorHex: input.colorHex,
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025),
    );
    created.add(npc);
    return npc;
  }

  @override
  Future<void> update(UpdateNpcInput input) async {}

  @override
  Future<void> delete(String id) async {}
}

class _FakeNodeRepo implements DialogueNodeRepository {
  final List<DialogueNode> created = [];
  int _counter = 0;

  @override
  Stream<List<DialogueNode>> watchByNpc(String npcId) => const Stream.empty();

  @override
  Future<DialogueNode> create(CreateNodeInput input) async {
    final node = DialogueNode(
      id: 'new-node-${_counter++}',
      npcId: input.npcId,
      speakerName: input.speakerName,
      dialogueText: input.dialogueText,
      isStart: input.isStart,
      layoutX: input.layoutX,
      layoutY: input.layoutY,
    );
    created.add(node);
    return node;
  }

  @override
  Future<void> update(UpdateNodeInput input) async {}

  @override
  Future<void> setStart(String nodeId) async {}

  @override
  Future<void> delete(String id) async {}
}

class _FakeChoiceRepo implements DialogueChoiceRepository {
  final List<DialogueChoice> created = [];
  int _counter = 0;

  @override
  Stream<List<DialogueChoice>> watchByNode(String fromNodeId) =>
      const Stream.empty();

  @override
  Stream<List<DialogueChoice>> watchAllByNpcId(String npcId) =>
      const Stream.empty();

  @override
  Future<DialogueChoice> create(CreateChoiceInput input) async {
    final choice = DialogueChoice(
      id: 'new-choice-${_counter++}',
      fromNodeId: input.fromNodeId,
      toNodeId: input.toNodeId,
      choiceText: input.choiceText,
      sortOrder: input.sortOrder,
    );
    created.add(choice);
    return choice;
  }

  @override
  Future<void> update(UpdateChoiceInput input) async {}

  @override
  Future<void> delete(String id) async {}
}

class _FakeReqFlagRepo implements RequirementFlagRepository {
  final List<RequirementFlag> created = [];
  int _counter = 0;

  @override
  Stream<List<RequirementFlag>> watchByChoice(String choiceId) =>
      const Stream.empty();

  @override
  Future<List<RequirementFlag>> getByChoiceIds(List<String> ids) async => [];

  @override
  Future<RequirementFlag> create(CreateRequirementFlagInput input) async {
    final flag = RequirementFlag(
      id: 'new-req-${_counter++}',
      choiceId: input.choiceId,
      flagName: input.flagName,
      requiredValue: input.requiredValue,
    );
    created.add(flag);
    return flag;
  }

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> deleteByChoiceId(String choiceId) async {}
}

class _FakeRewFlagRepo implements RewardFlagRepository {
  final List<RewardFlag> created = [];
  int _counter = 0;

  @override
  Stream<List<RewardFlag>> watchByNode(String nodeId) => const Stream.empty();

  @override
  Future<List<RewardFlag>> getByNodeIds(List<String> ids) async => [];

  @override
  Future<RewardFlag> create(CreateRewardFlagInput input) async {
    final flag = RewardFlag(
      id: 'new-rew-${_counter++}',
      nodeId: input.nodeId,
      flagName: input.flagName,
      setValue: input.setValue,
    );
    created.add(flag);
    return flag;
  }

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> deleteByNodeId(String nodeId) async {}
}

ImportService _makeService({
  _FakeNpcRepo? npcRepo,
  _FakeNodeRepo? nodeRepo,
  _FakeChoiceRepo? choiceRepo,
  _FakeReqFlagRepo? reqRepo,
  _FakeRewFlagRepo? rewRepo,
}) {
  return ImportService(
    npcRepo: npcRepo ?? _FakeNpcRepo(),
    nodeRepo: nodeRepo ?? _FakeNodeRepo(),
    choiceRepo: choiceRepo ?? _FakeChoiceRepo(),
    reqFlagRepo: reqRepo ?? _FakeReqFlagRepo(),
    rewFlagRepo: rewRepo ?? _FakeRewFlagRepo(),
  );
}

Map<String, dynamic> _buildExportMap({
  String npcName = 'Elara',
  List<Map<String, dynamic>>? nodes,
  List<Map<String, dynamic>>? choices,
  List<Map<String, dynamic>>? reqFlags,
  List<Map<String, dynamic>>? rewFlags,
}) {
  return {
    'version': 1,
    'exportedAt': DateTime(2025).toIso8601String(),
    'npc': {
      'id': 'old-npc',
      'name': npcName,
      'description': '',
      'colorHex': '#7B61FF',
      'canvasX': 100.0,
      'canvasY': 200.0,
    },
    'nodes': nodes ?? [],
    'choices': choices ?? [],
    'requirementFlags': reqFlags ?? [],
    'rewardFlags': rewFlags ?? [],
  };
}

void main() {
  group('ImportService', () {
    test('creates NPC with correct name', () async {
      final npcRepo = _FakeNpcRepo();
      final service = _makeService(npcRepo: npcRepo);
      final map = _buildExportMap(npcName: 'Gandalf');
      final result = await service.importFromMap(map);
      expect(result.npc.name, 'Gandalf');
      expect(npcRepo.created.length, 1);
    });

    test('creates nodes and remaps IDs for choices', () async {
      final nodeRepo = _FakeNodeRepo();
      final choiceRepo = _FakeChoiceRepo();
      final service = _makeService(nodeRepo: nodeRepo, choiceRepo: choiceRepo);

      final map = _buildExportMap(
        nodes: [
          {
            'id': 'old-n1',
            'speakerName': 'Hero',
            'dialogueText': 'Hello',
            'isStart': true,
            'layoutX': 0.0,
            'layoutY': 0.0,
          },
          {
            'id': 'old-n2',
            'speakerName': 'Hero',
            'dialogueText': 'Bye',
            'isStart': false,
            'layoutX': 200.0,
            'layoutY': 0.0,
          },
        ],
        choices: [
          {
            'id': 'old-c1',
            'fromNodeId': 'old-n1',
            'toNodeId': 'old-n2',
            'choiceText': 'Leave',
            'sortOrder': 0,
          }
        ],
      );

      final result = await service.importFromMap(map);
      expect(result.nodeCount, 2);
      expect(nodeRepo.created.length, 2);
      expect(choiceRepo.created.length, 1);

      final choice = choiceRepo.created.first;
      expect(choice.fromNodeId, nodeRepo.created[0].id);
      expect(choice.toNodeId, nodeRepo.created[1].id);
    });

    test('remaps requirement flag choiceId to new ID', () async {
      final choiceRepo = _FakeChoiceRepo();
      final reqRepo = _FakeReqFlagRepo();
      final service = _makeService(choiceRepo: choiceRepo, reqRepo: reqRepo);

      final map = _buildExportMap(
        nodes: [
          {
            'id': 'old-n1',
            'speakerName': 'A',
            'dialogueText': 'T',
            'isStart': true,
            'layoutX': 0.0,
            'layoutY': 0.0,
          }
        ],
        choices: [
          {
            'id': 'old-c1',
            'fromNodeId': 'old-n1',
            'toNodeId': null,
            'choiceText': 'Try',
            'sortOrder': 0,
          }
        ],
        reqFlags: [
          {
            'id': 'old-rf1',
            'choiceId': 'old-c1',
            'flagName': 'met_elder',
            'requiredValue': true,
          }
        ],
      );

      await service.importFromMap(map);
      expect(reqRepo.created.length, 1);
      expect(reqRepo.created.first.choiceId, choiceRepo.created.first.id);
    });

    test('remaps reward flag nodeId to new ID', () async {
      final nodeRepo = _FakeNodeRepo();
      final rewRepo = _FakeRewFlagRepo();
      final service = _makeService(nodeRepo: nodeRepo, rewRepo: rewRepo);

      final map = _buildExportMap(
        nodes: [
          {
            'id': 'old-n1',
            'speakerName': 'B',
            'dialogueText': 'T',
            'isStart': true,
            'layoutX': 0.0,
            'layoutY': 0.0,
          }
        ],
        rewFlags: [
          {
            'id': 'old-rw1',
            'nodeId': 'old-n1',
            'flagName': 'quest_started',
            'setValue': true,
          }
        ],
      );

      await service.importFromMap(map);
      expect(rewRepo.created.length, 1);
      expect(rewRepo.created.first.nodeId, nodeRepo.created.first.id);
    });

    test('throws FormatException for unsupported version', () async {
      final service = _makeService();
      final map = _buildExportMap()..['version'] = 99;
      expect(
        () => service.importFromMap(map),
        throwsA(isA<FormatException>()),
      );
    });

    test('round-trip: export then import preserves NPC name and node count',
        () async {
      final epoch = DateTime.fromMillisecondsSinceEpoch(0);
      final npc = Npc(
        id: 'npc-1',
        name: 'Elara',
        description: 'A merchant',
        canvasX: 0,
        canvasY: 0,
        colorHex: '#7B61FF',
        createdAt: epoch,
        updatedAt: epoch,
      );
      final node = DialogueNode(
        id: 'n1',
        npcId: 'npc-1',
        speakerName: 'Elara',
        dialogueText: 'Hi',
        isStart: true,
        layoutX: 0,
        layoutY: 0,
      );
      final data = NpcGraphData(
        npc: npc,
        nodes: [node],
        choices: [],
        requirementFlags: [],
        rewardFlags: [],
      );

      const exporter = ExportService();
      final map = exporter.buildJsonMap(data);

      final npcRepo = _FakeNpcRepo();
      final nodeRepo = _FakeNodeRepo();
      final service = _makeService(npcRepo: npcRepo, nodeRepo: nodeRepo);
      final result = await service.importFromMap(map);

      expect(result.npc.name, 'Elara');
      expect(result.nodeCount, 1);
      expect(nodeRepo.created.first.speakerName, 'Elara');
    });
  });
}
