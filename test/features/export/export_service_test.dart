import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/domain/entities/dialogue_choice.dart';
import 'package:gamestory/domain/entities/dialogue_node.dart';
import 'package:gamestory/domain/entities/npc.dart';
import 'package:gamestory/domain/entities/project.dart';
import 'package:gamestory/domain/entities/requirement_flag.dart';
import 'package:gamestory/domain/entities/reward_flag.dart';
import 'package:gamestory/features/export/services/gsp_export_service.dart';

NpcGraphData _makeNpcData({
  List<DialogueNode>? nodes,
  List<DialogueChoice>? choices,
  List<RequirementFlag>? reqFlags,
  List<RewardFlag>? rewFlags,
}) {
  final now = DateTime(2025, 1, 1);
  return NpcGraphData(
    npc: Npc(
      id: 'npc-1',
      projectId: 'proj-1',
      name: 'Elara',
      description: 'A wise merchant',
      canvasX: 100,
      canvasY: 200,
      colorHex: '#7B61FF',
      createdAt: now,
      updatedAt: now,
    ),
    nodes: nodes ?? [],
    choices: choices ?? [],
    requirementFlags: reqFlags ?? [],
    rewardFlags: rewFlags ?? [],
  );
}

Project _makeProject() {
  final now = DateTime(2025, 1, 1);
  return Project(
    id: 'proj-1',
    name: 'Test Project',
    description: 'desc',
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  const service = GspExportService();
  final project = _makeProject();

  group('GspExportService — buildGspMap', () {
    test('produces valid map with schemaVersion 1 and project name', () {
      final map = service.buildGspMap(project, []);
      expect(map['schemaVersion'], 1);
      expect((map['project'] as Map)['name'], 'Test Project');
      expect(map['npcs'], isEmpty);
    });

    test('serialises NPC with nodes and choices', () {
      const node1 = DialogueNode(
        id: 'n1',
        npcId: 'npc-1',
        speakerName: 'Elara',
        dialogueText: 'Hello traveller',
        isStart: true,
        layoutX: 0,
        layoutY: 0,
      );
      const node2 = DialogueNode(
        id: 'n2',
        npcId: 'npc-1',
        speakerName: 'Elara',
        dialogueText: 'Goodbye',
        isStart: false,
        layoutX: 200,
        layoutY: 0,
      );
      const choice = DialogueChoice(
        id: 'c1',
        fromNodeId: 'n1',
        toNodeId: 'n2',
        choiceText: 'Leave',
        sortOrder: 0,
      );

      final data = _makeNpcData(nodes: [node1, node2], choices: [choice]);
      final map = service.buildGspMap(project, [data]);

      final npcs = map['npcs'] as List;
      expect(npcs.length, 1);

      final npcMap = npcs[0] as Map;
      expect(npcMap['name'], 'Elara');

      final nodes = npcMap['nodes'] as List;
      expect(nodes.length, 2);
      expect((nodes[0] as Map)['id'], 'n1');
      expect((nodes[0] as Map)['isStart'], true);

      final choices = npcMap['choices'] as List;
      expect(choices.length, 1);
      expect((choices[0] as Map)['fromNodeId'], 'n1');
      expect((choices[0] as Map)['toNodeId'], 'n2');
    });

    test('serialises requirement and reward flags', () {
      const req = RequirementFlag(
        id: 'rf1',
        choiceId: 'c1',
        flagName: 'met_elder',
        requiredValue: true,
      );
      const rew = RewardFlag(
        id: 'rw1',
        nodeId: 'n1',
        flagName: 'quest_started',
        setValue: true,
      );

      final data = _makeNpcData(reqFlags: [req], rewFlags: [rew]);
      final map = service.buildGspMap(project, [data]);
      final npcMap = (map['npcs'] as List)[0] as Map;

      final reqFlags = npcMap['requirementFlags'] as List;
      expect(reqFlags.length, 1);
      expect((reqFlags[0] as Map)['flagName'], 'met_elder');
      expect((reqFlags[0] as Map)['requiredValue'], true);

      final rewFlags = npcMap['rewardFlags'] as List;
      expect(rewFlags.length, 1);
      expect((rewFlags[0] as Map)['flagName'], 'quest_started');
      expect((rewFlags[0] as Map)['setValue'], true);
    });

    test('round-trips through JSON encode/decode', () {
      final data = _makeNpcData();
      final map = service.buildGspMap(project, [data]);
      final encoded = jsonEncode(map);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      expect(decoded['schemaVersion'], 1);
      expect((decoded['project'] as Map)['name'], 'Test Project');
    });
  });
}
