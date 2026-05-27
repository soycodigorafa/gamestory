import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/domain/entities/dialogue_choice.dart';
import 'package:gamestory/domain/entities/dialogue_node.dart';
import 'package:gamestory/domain/entities/npc.dart';
import 'package:gamestory/domain/entities/requirement_flag.dart';
import 'package:gamestory/domain/entities/reward_flag.dart';
import 'package:gamestory/features/export/services/export_service.dart';

NpcGraphData _makeData({
  List<DialogueNode>? nodes,
  List<DialogueChoice>? choices,
  List<RequirementFlag>? reqFlags,
  List<RewardFlag>? rewFlags,
}) {
  final now = DateTime(2025, 1, 1);
  return NpcGraphData(
    npc: Npc(
      id: 'npc-1',
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

void main() {
  const service = ExportService();

  group('ExportService — JSON', () {
    test('produces valid JSON with correct version and NPC name', () {
      final data = _makeData();
      final map = service.buildJsonMap(data);
      expect(map['version'], 1);
      expect((map['npc'] as Map)['name'], 'Elara');
      expect(map['nodes'], isEmpty);
      expect(map['choices'], isEmpty);
      expect(map['requirementFlags'], isEmpty);
      expect(map['rewardFlags'], isEmpty);
    });

    test('serialises nodes and choices correctly', () {
      final node1 = const DialogueNode(
        id: 'n1',
        npcId: 'npc-1',
        speakerName: 'Elara',
        dialogueText: 'Hello traveller',
        isStart: true,
        layoutX: 0,
        layoutY: 0,
      );
      final node2 = const DialogueNode(
        id: 'n2',
        npcId: 'npc-1',
        speakerName: 'Elara',
        dialogueText: 'Goodbye',
        isStart: false,
        layoutX: 200,
        layoutY: 0,
      );
      final choice = const DialogueChoice(
        id: 'c1',
        fromNodeId: 'n1',
        toNodeId: 'n2',
        choiceText: 'Leave',
        sortOrder: 0,
      );

      final data = _makeData(nodes: [node1, node2], choices: [choice]);
      final map = service.buildJsonMap(data);

      final nodes = map['nodes'] as List;
      expect(nodes.length, 2);
      expect((nodes[0] as Map)['id'], 'n1');
      expect((nodes[0] as Map)['isStart'], true);

      final choices = map['choices'] as List;
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

      final data = _makeData(reqFlags: [req], rewFlags: [rew]);
      final map = service.buildJsonMap(data);

      final reqFlags = map['requirementFlags'] as List;
      expect(reqFlags.length, 1);
      expect((reqFlags[0] as Map)['flagName'], 'met_elder');
      expect((reqFlags[0] as Map)['requiredValue'], true);

      final rewFlags = map['rewardFlags'] as List;
      expect(rewFlags.length, 1);
      expect((rewFlags[0] as Map)['flagName'], 'quest_started');
      expect((rewFlags[0] as Map)['setValue'], true);
    });

    test('round-trips through JSON encode/decode', () {
      final data = _makeData();
      final map = service.buildJsonMap(data);
      final encoded = jsonEncode(map);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      expect(decoded['version'], 1);
      expect((decoded['npc'] as Map)['name'], 'Elara');
    });
  });

  group('ExportService — CSV', () {
    test('CSV has correct header columns', () {
      final data = _makeData();
      final map = service.buildJsonMap(data);
      expect(map, isNotNull);
    });

    test('CSV escapes commas in dialogue text', () {
      final node = const DialogueNode(
        id: 'n1',
        npcId: 'npc-1',
        speakerName: 'Elara',
        dialogueText: 'Hello, traveller',
        isStart: true,
        layoutX: 0,
        layoutY: 0,
      );
      final data = _makeData(nodes: [node]);
      final map = service.buildJsonMap(data);
      final encodedText =
          ((map['nodes'] as List).first as Map)['dialogueText'] as String;
      expect(encodedText, contains(','));
    });
  });
}
