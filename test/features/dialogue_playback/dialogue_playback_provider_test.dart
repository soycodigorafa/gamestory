import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/features/dialogue_playback/providers/dialogue_playback_provider.dart';

void main() {
  const projectId = 'proj_1';

  // node_1 is the root node in StubData for all projects
  const rootNodeId = 'node_1';
  // node_2 and node_3 are direct children of node_1
  const child1Id = 'node_2';
  const child2Id = 'node_3';
  // node_4 is a child of node_2 (leaf under that branch)
  // node_5 is a child of node_3 (leaf under that branch)

  ProviderContainer buildContainer() => ProviderContainer();

  tearDown(() {});

  group('DialoguePlayback — initial state', () {
    test('starts at the given start node', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));

      expect(state.currentNode.id, equals(rootNodeId));
    });

    test('history is empty at start', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));

      expect(state.history, isEmpty);
      expect(state.canGoBack, isFalse);
    });

    test('start node is in visitedNodeIds', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));

      expect(state.visitedNodeIds, contains(rootNodeId));
    });

    test('initial flagValues have all flags set to false', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));

      for (final value in state.flagValues.values) {
        expect(value, isFalse);
      }
    });
  });

  group('DialoguePlayback — chooseNode', () {
    test('advances to chosen node', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      final children = notifier.childrenOf(rootNodeId);
      final chosenChild =
          children.firstWhere((n) => n.id == child1Id);

      notifier.chooseNode(chosenChild);

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      expect(state.currentNode.id, equals(child1Id));
    });

    test('adds previous node to history', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      final children = notifier.childrenOf(rootNodeId);
      final chosenChild =
          children.firstWhere((n) => n.id == child1Id);

      notifier.chooseNode(chosenChild);

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      expect(state.history.length, equals(1));
      expect(state.history.first.id, equals(rootNodeId));
      expect(state.canGoBack, isTrue);
    });

    test('adds chosen node to visitedNodeIds', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      final children = notifier.childrenOf(rootNodeId);
      final chosenChild =
          children.firstWhere((n) => n.id == child1Id);

      notifier.chooseNode(chosenChild);

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      expect(state.visitedNodeIds, containsAll([rootNodeId, child1Id]));
    });

    test('accumulates item unlocks when choosing a node with unlocks', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      // node_2 has conditionIds but no unlocks; node_3 also has none.
      // node_1 (root) itself has unlockedItemIds: ['item_1'].
      // After choosing node_2 (no unlocks), item_1 should still be in set.
      final children = notifier.childrenOf(rootNodeId);
      final chosenChild =
          children.firstWhere((n) => n.id == child2Id);

      notifier.chooseNode(chosenChild);

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      // item_1 was on root node, should persist
      expect(state.unlockedItemIds, contains('item_1'));
    });
  });

  group('DialoguePlayback — goBack', () {
    test('returns to the previous node', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      final children = notifier.childrenOf(rootNodeId);
      notifier.chooseNode(children.firstWhere((n) => n.id == child1Id));
      notifier.goBack();

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      expect(state.currentNode.id, equals(rootNodeId));
    });

    test('removes last entry from history', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      final children = notifier.childrenOf(rootNodeId);
      notifier.chooseNode(children.firstWhere((n) => n.id == child1Id));
      notifier.goBack();

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      expect(state.history, isEmpty);
      expect(state.canGoBack, isFalse);
    });

    test('is a no-op when history is empty', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      notifier.goBack(); // no-op

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      expect(state.currentNode.id, equals(rootNodeId));
    });
  });

  group('DialoguePlayback — restart', () {
    test('resets to start node', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      final children = notifier.childrenOf(rootNodeId);
      notifier.chooseNode(children.firstWhere((n) => n.id == child1Id));
      notifier.restart();

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      expect(state.currentNode.id, equals(rootNodeId));
    });

    test('clears history on restart', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      final children = notifier.childrenOf(rootNodeId);
      notifier.chooseNode(children.firstWhere((n) => n.id == child1Id));
      notifier.restart();

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      expect(state.history, isEmpty);
      expect(state.canGoBack, isFalse);
    });

    test('resets flagValues to all false on restart', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      notifier.restart();

      final state =
          container.read(dialoguePlaybackProvider(projectId, rootNodeId));
      for (final value in state.flagValues.values) {
        expect(value, isFalse);
      }
    });
  });

  group('DialoguePlayback — isDeadEnd', () {
    test('root node is not a dead end', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      expect(notifier.isDeadEnd(rootNodeId), isFalse);
    });

    test('leaf nodes are dead ends', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      // node_4 and node_5 are leaves in stub data
      expect(notifier.isDeadEnd('node_4'), isTrue);
      expect(notifier.isDeadEnd('node_5'), isTrue);
    });
  });

  group('DialoguePlayback — isNodeGated', () {
    test('node with no conditions is not gated', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      // node_3 has no conditionIds
      final children = notifier.childrenOf(rootNodeId);
      final node3 = children.firstWhere((n) => n.id == child2Id);
      expect(notifier.isNodeGated(node3), isFalse);
    });

    test('node with unmet flag condition is gated', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      // node_2 has conditionIds: ['cond_1'] which is a flag type, default false
      final children = notifier.childrenOf(rootNodeId);
      final node2 = children.firstWhere((n) => n.id == child1Id);
      expect(notifier.isNodeGated(node2), isTrue);
    });
  });

  group('DialoguePlayback — childrenOf', () {
    test('returns children sorted by sortOrder', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      final children = notifier.childrenOf(rootNodeId);

      expect(children.length, equals(2));
      expect(children[0].sortOrder <= children[1].sortOrder, isTrue);
    });

    test('returns empty list for a leaf node', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container
          .read(dialoguePlaybackProvider(projectId, rootNodeId).notifier);
      expect(notifier.childrenOf('node_4'), isEmpty);
    });
  });
}
