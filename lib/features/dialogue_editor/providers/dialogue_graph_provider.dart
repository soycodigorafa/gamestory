import 'dart:collection';
import 'dart:math' show max;

import 'package:flutter/widgets.dart' show Axis;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/drift_dialogue_choice_repository.dart';
import '../../../data/repositories/drift_dialogue_node_repository.dart';
import '../../../domain/entities/dialogue_choice.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../domain/repositories/dialogue_choice_repository.dart';
import '../../../domain/repositories/dialogue_node_repository.dart';
import '../../canvas/providers/npc_list_provider.dart';

part 'dialogue_graph_provider.g.dart';

class DialogueGraphState {
  const DialogueGraphState({required this.nodes, required this.choices});

  final List<DialogueNode> nodes;
  final List<DialogueChoice> choices;
}

@Riverpod(keepAlive: true)
DialogueNodeRepository dialogueNodeRepository(DialogueNodeRepositoryRef ref) {
  return DriftDialogueNodeRepository(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
DialogueChoiceRepository dialogueChoiceRepository(
    DialogueChoiceRepositoryRef ref) {
  return DriftDialogueChoiceRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<DialogueNode>> dialogueNodesList(
    DialogueNodesListRef ref, String npcId) {
  return ref.watch(dialogueNodeRepositoryProvider).watchByNpc(npcId);
}

@riverpod
Stream<List<DialogueChoice>> dialogueChoicesList(
    DialogueChoicesListRef ref, String npcId) {
  return ref.watch(dialogueChoiceRepositoryProvider).watchAllByNpcId(npcId);
}

@riverpod
class DialogueGraph extends _$DialogueGraph {
  @override
  Future<DialogueGraphState> build(String npcId) async {
    final nodes = await ref.watch(dialogueNodesListProvider(npcId).future);
    final choices = await ref.watch(dialogueChoicesListProvider(npcId).future);
    return DialogueGraphState(nodes: nodes, choices: choices);
  }

  Future<DialogueNode> addNode({
    double layoutX = 100,
    double layoutY = 100,
  }) async {
    final graph = await future;
    final isFirst = graph.nodes.isEmpty;
    return ref.read(dialogueNodeRepositoryProvider).create(CreateNodeInput(
          npcId: npcId,
          isStart: isFirst,
          layoutX: layoutX,
          layoutY: layoutY,
        ));
  }

  Future<void> moveNode(String nodeId, double x, double y) {
    return ref
        .read(dialogueNodeRepositoryProvider)
        .update(UpdateNodeInput(id: nodeId, layoutX: x, layoutY: y));
  }

  Future<void> setStart(String nodeId) {
    return ref.read(dialogueNodeRepositoryProvider).setStart(nodeId);
  }

  Future<void> deleteNode(String nodeId) async {
    final graph = await future;
    final choiceRepo = ref.read(dialogueChoiceRepositoryProvider);

    for (final c in graph.choices.where((c) => c.toNodeId == nodeId)) {
      await choiceRepo.update(UpdateChoiceInput(id: c.id, clearToNodeId: true));
    }
    for (final c in graph.choices.where((c) => c.fromNodeId == nodeId)) {
      await choiceRepo.delete(c.id);
    }
    await ref.read(dialogueNodeRepositoryProvider).delete(nodeId);
  }

  Future<void> autoArrange() async {
    final graph = await future;
    if (graph.nodes.isEmpty) return;

    final direction = ref.read(layoutDirectionProvider);
    final adjacency = <String, List<String>>{};
    for (final choice in graph.choices) {
      if (choice.toNodeId != null) {
        adjacency.putIfAbsent(choice.fromNodeId, () => []).add(choice.toNodeId!);
      }
    }

    final startNode = graph.nodes.firstWhere(
      (n) => n.isStart,
      orElse: () => graph.nodes.first,
    );

    final levels = <String, int>{};
    final visited = <String>{};
    final queue = Queue<String>();
    queue.add(startNode.id);
    visited.add(startNode.id);
    levels[startNode.id] = 0;

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      for (final child in adjacency[current] ?? <String>[]) {
        if (!visited.contains(child)) {
          visited.add(child);
          levels[child] = (levels[current] ?? 0) + 1;
          queue.add(child);
        }
      }
    }

    final byLevel = <int, List<String>>{};
    for (final entry in levels.entries) {
      byLevel.putIfAbsent(entry.value, () => []).add(entry.key);
    }

    final unreachable =
        graph.nodes.where((n) => !visited.contains(n.id)).map((n) => n.id).toList();
    if (unreachable.isNotEmpty) {
      final maxLevel = byLevel.keys.reduce(max);
      byLevel[maxLevel + 1] = unreachable;
    }

    const spacing = 220.0;
    const origin = 80.0;
    final nodeRepo = ref.read(dialogueNodeRepositoryProvider);

    for (final entry in byLevel.entries) {
      final level = entry.key;
      final nodeIds = entry.value;
      for (int i = 0; i < nodeIds.length; i++) {
        final x = direction == Axis.vertical
            ? origin + i * spacing
            : origin + level * spacing;
        final y = direction == Axis.vertical
            ? origin + level * spacing
            : origin + i * spacing;
        await nodeRepo.update(UpdateNodeInput(id: nodeIds[i], layoutX: x, layoutY: y));
      }
    }
  }
}

@riverpod
class LayoutDirection extends _$LayoutDirection {
  @override
  Axis build() => Axis.vertical;

  void toggle() {
    state = state == Axis.vertical ? Axis.horizontal : Axis.vertical;
  }
}
