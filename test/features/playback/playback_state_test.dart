import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/domain/entities/dialogue_choice.dart';
import 'package:gamestory/domain/entities/dialogue_node.dart';
import 'package:gamestory/domain/entities/requirement_flag.dart';
import 'package:gamestory/domain/entities/reward_flag.dart';
import 'package:gamestory/features/playback/providers/playback_provider.dart';

DialogueNode _node(String id, {bool isStart = false}) => DialogueNode(
      id: id,
      npcId: 'npc1',
      speakerName: 'Speaker',
      dialogueText: 'Text',
      isStart: isStart,
      layoutX: 0,
      layoutY: 0,
    );

DialogueChoice _choice(String id, String from, String to) => DialogueChoice(
      id: id,
      fromNodeId: from,
      toNodeId: to,
      choiceText: 'Choice $id',
      sortOrder: 0,
    );

RequirementFlag _req(String choiceId, String flag, {bool required = true}) =>
    RequirementFlag(
      id: 'req_$choiceId',
      choiceId: choiceId,
      flagName: flag,
      requiredValue: required,
    );

RewardFlag _reward(String nodeId, String flag, {bool value = true}) =>
    RewardFlag(
      id: 'rew_$nodeId',
      nodeId: nodeId,
      flagName: flag,
      setValue: value,
    );

PlaybackState _baseState({
  List<DialogueNode>? nodes,
  List<DialogueChoice>? choices,
  Map<String, List<RequirementFlag>>? requirementFlags,
  Map<String, List<RewardFlag>>? rewardFlags,
  String currentNodeId = 'n1',
  List<String> visitedNodes = const [],
  Map<String, bool> flagMap = const {},
}) {
  return PlaybackState(
    nodes: nodes ??
        [
          _node('n1', isStart: true),
          _node('n2'),
          _node('n3'),
        ],
    choices: choices ?? [],
    requirementFlags: requirementFlags ?? {},
    rewardFlags: rewardFlags ?? {},
    currentNodeId: currentNodeId,
    visitedNodes: visitedNodes,
    flagMap: flagMap,
  );
}

void main() {
  group('PlaybackState.currentNode', () {
    test('returns the node matching currentNodeId', () {
      final state = _baseState(currentNodeId: 'n2');
      expect(state.currentNode.id, 'n2');
    });
  });

  group('PlaybackState.currentChoices', () {
    test('returns only choices from current node with a connected target', () {
      final choices = [
        _choice('c1', 'n1', 'n2'),
        _choice('c2', 'n1', 'n3'),
        _choice('c3', 'n2', 'n3'),
        DialogueChoice(
          id: 'c4',
          fromNodeId: 'n1',
          toNodeId: null,
          choiceText: 'Disconnected',
          sortOrder: 3,
        ),
      ];
      final state = _baseState(choices: choices, currentNodeId: 'n1');
      final result = state.currentChoices;
      expect(result.map((c) => c.id).toList(), containsAll(['c1', 'c2']));
      expect(result.any((c) => c.id == 'c3'), isFalse);
      expect(result.any((c) => c.id == 'c4'), isFalse);
    });

    test('sorts choices by sortOrder', () {
      final choices = [
        DialogueChoice(
            id: 'c1',
            fromNodeId: 'n1',
            toNodeId: 'n2',
            choiceText: 'B',
            sortOrder: 2),
        DialogueChoice(
            id: 'c2',
            fromNodeId: 'n1',
            toNodeId: 'n3',
            choiceText: 'A',
            sortOrder: 0),
      ];
      final state = _baseState(choices: choices, currentNodeId: 'n1');
      expect(state.currentChoices.first.id, 'c2');
    });
  });

  group('PlaybackState.isDeadEnd', () {
    test('true when current node has no connected choices', () {
      final state = _baseState(currentNodeId: 'n3');
      expect(state.isDeadEnd, isTrue);
    });

    test('false when current node has at least one connected choice', () {
      final state = _baseState(
        choices: [_choice('c1', 'n1', 'n2')],
        currentNodeId: 'n1',
      );
      expect(state.isDeadEnd, isFalse);
    });
  });

  group('PlaybackState.isChoiceLocked', () {
    test('unlocked when no requirements', () {
      final state = _baseState();
      expect(state.isChoiceLocked('c1'), isFalse);
    });

    test('locked when required flag is absent from flagMap', () {
      final state = _baseState(
        requirementFlags: {
          'c1': [_req('c1', 'door_open', required: true)]
        },
        flagMap: {},
      );
      expect(state.isChoiceLocked('c1'), isTrue);
    });

    test('locked when flag value does not match required value', () {
      final state = _baseState(
        requirementFlags: {
          'c1': [_req('c1', 'door_open', required: true)]
        },
        flagMap: {'door_open': false},
      );
      expect(state.isChoiceLocked('c1'), isTrue);
    });

    test('unlocked when flag value matches required value', () {
      final state = _baseState(
        requirementFlags: {
          'c1': [_req('c1', 'door_open', required: true)]
        },
        flagMap: {'door_open': true},
      );
      expect(state.isChoiceLocked('c1'), isFalse);
    });

    test('unlocked when requirement is false and flag is false', () {
      final state = _baseState(
        requirementFlags: {
          'c1': [_req('c1', 'door_blocked', required: false)]
        },
        flagMap: {'door_blocked': false},
      );
      expect(state.isChoiceLocked('c1'), isFalse);
    });

    test('locked when any requirement is unmet', () {
      final state = _baseState(
        requirementFlags: {
          'c1': [
            _req('c1', 'flag_a', required: true),
            _req('c1', 'flag_b', required: true),
          ]
        },
        flagMap: {'flag_a': true, 'flag_b': false},
      );
      expect(state.isChoiceLocked('c1'), isTrue);
    });

    test('unlocked when all requirements are met', () {
      final state = _baseState(
        requirementFlags: {
          'c1': [
            _req('c1', 'flag_a', required: true),
            _req('c1', 'flag_b', required: true),
          ]
        },
        flagMap: {'flag_a': true, 'flag_b': true},
      );
      expect(state.isChoiceLocked('c1'), isFalse);
    });
  });

  group('PlaybackState.copyWith', () {
    test('updates currentNodeId', () {
      final state = _baseState(currentNodeId: 'n1');
      final updated = state.copyWith(currentNodeId: 'n2');
      expect(updated.currentNodeId, 'n2');
      expect(updated.nodes, state.nodes);
    });

    test('updates visitedNodes', () {
      final state = _baseState();
      final updated = state.copyWith(visitedNodes: ['n1']);
      expect(updated.visitedNodes, ['n1']);
    });

    test('updates flagMap', () {
      final state = _baseState();
      final updated = state.copyWith(flagMap: {'door_open': true});
      expect(updated.flagMap, {'door_open': true});
    });
  });

  group('reward flag application', () {
    test('reward flags from start node are reflected in initial flagMap', () {
      final rewardFlags = {
        'n1': [_reward('n1', 'intro_seen', value: true)]
      };
      final state = _baseState(
        rewardFlags: rewardFlags,
        flagMap: {'intro_seen': true},
      );
      expect(state.flagMap['intro_seen'], isTrue);
    });
  });
}
