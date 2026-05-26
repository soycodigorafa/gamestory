import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/domain/entities/dialogue_node.dart';
import 'package:gamestory/domain/entities/playback_state.dart';

void main() {
  final nodeA = DialogueNode(
    id: 'a',
    projectId: 'p1',
    parentId: null,
    speakerName: 'NPC',
    dialogueText: 'Hello',
    sortOrder: 0,
  );

  final nodeB = DialogueNode(
    id: 'b',
    projectId: 'p1',
    parentId: 'a',
    speakerName: 'Player',
    dialogueText: 'Hi back',
    sortOrder: 0,
    unlockedItemIds: ['item_x'],
  );

  final nodeC = DialogueNode(
    id: 'c',
    projectId: 'p1',
    parentId: 'a',
    speakerName: 'Player',
    dialogueText: 'Goodbye',
    sortOrder: 1,
    conditionIds: ['cond_1'],
  );

  group('PlaybackState', () {
    late PlaybackState initial;

    setUp(() {
      initial = PlaybackState(
        currentNode: nodeA,
        history: const [],
        visitedNodeIds: {'a'},
        unlockedItemIds: const {},
        flagValues: const {'cond_1': false},
      );
    });

    test('canGoBack is false when history is empty', () {
      expect(initial.canGoBack, isFalse);
    });

    test('canGoBack is true when history has entries', () {
      final state = initial.copyWith(history: [nodeA]);
      expect(state.canGoBack, isTrue);
    });

    group('copyWith', () {
      test('returns new state with updated currentNode', () {
        final updated = initial.copyWith(currentNode: nodeB);
        expect(updated.currentNode.id, equals('b'));
        expect(updated.history, isEmpty);
      });

      test('returns new state with updated history', () {
        final updated = initial.copyWith(history: [nodeA]);
        expect(updated.history.length, equals(1));
        expect(updated.history.first.id, equals('a'));
      });

      test('returns new state with updated visitedNodeIds', () {
        final updated = initial.copyWith(visitedNodeIds: {'a', 'b'});
        expect(updated.visitedNodeIds, containsAll(['a', 'b']));
      });

      test('returns new state with updated unlockedItemIds', () {
        final updated = initial.copyWith(unlockedItemIds: {'item_x'});
        expect(updated.unlockedItemIds, contains('item_x'));
      });

      test('returns new state with updated flagValues', () {
        final updated = initial.copyWith(flagValues: {'cond_1': true});
        expect(updated.flagValues['cond_1'], isTrue);
      });

      test('preserves unchanged fields', () {
        final updated = initial.copyWith(currentNode: nodeB);
        expect(updated.visitedNodeIds, equals(initial.visitedNodeIds));
        expect(updated.flagValues, equals(initial.flagValues));
      });
    });

    group('condition gating (via flagValues)', () {
      test('flag condition is false by default', () {
        expect(initial.flagValues['cond_1'], isFalse);
      });

      test('flag condition can be set to true via copyWith', () {
        final met = initial.copyWith(flagValues: {'cond_1': true});
        expect(met.flagValues['cond_1'], isTrue);
      });

      test('nodeC has conditionIds that reference cond_1', () {
        expect(nodeC.conditionIds, contains('cond_1'));
      });

      test('nodeC is gated when cond_1 flag is false', () {
        final isGated = nodeC.conditionIds
            .any((id) => !(initial.flagValues[id] ?? false));
        expect(isGated, isTrue);
      });

      test('nodeC is not gated when cond_1 flag is true', () {
        final met = initial.copyWith(flagValues: {'cond_1': true});
        final isGated = nodeC.conditionIds
            .any((id) => !(met.flagValues[id] ?? false));
        expect(isGated, isFalse);
      });
    });

    group('item unlocks accumulate', () {
      test('merging unlockedItemIds from a choice', () {
        final after = initial.copyWith(
          unlockedItemIds: {
            ...initial.unlockedItemIds,
            ...nodeB.unlockedItemIds,
          },
        );
        expect(after.unlockedItemIds, contains('item_x'));
      });
    });
  });
}
