import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/dialogue_node.dart';
import '../../../features/canvas/providers/npc_list_provider.dart';
import '../../../shared/widgets/gs_animated_card.dart';
import '../../../shared/widgets/gs_dialog.dart';
import '../../../shared/widgets/gs_empty_state.dart';
import '../../../shared/widgets/gs_text_field.dart';
import '../providers/dialogue_graph_provider.dart';
import '../widgets/node_card.dart';
import '../widgets/node_connection_painter.dart';
import 'node_edit_sheet.dart';

class DialogueEditorScreen extends ConsumerStatefulWidget {
  const DialogueEditorScreen({super.key, required this.npcId});

  final String npcId;

  @override
  ConsumerState<DialogueEditorScreen> createState() =>
      _DialogueEditorScreenState();
}

class _DialogueEditorScreenState extends ConsumerState<DialogueEditorScreen> {
  final Map<String, Offset> _localOffsets = {};
  final Set<String> _exitingIds = {};

  static const _animationDuration = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    final graphAsync = ref.watch(dialogueGraphProvider(widget.npcId));
    final direction = ref.watch(layoutDirectionProvider);
    final npcName = ref
            .watch(npcListProvider)
            .valueOrNull
            ?.where((n) => n.id == widget.npcId)
            .firstOrNull
            ?.name ??
        'Dialogue Editor';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => context.goNamed('canvas'),
        ),
        title: Text(npcName),
        actions: [
          IconButton(
            icon: Icon(direction == Axis.vertical
                ? Icons.swap_horiz
                : Icons.swap_vert),
            tooltip: direction == Axis.vertical
                ? 'Switch to horizontal layout'
                : 'Switch to vertical layout',
            onPressed: () {
                ref.read(layoutDirectionProvider.notifier).toggle();
                ref
                    .read(dialogueGraphProvider(widget.npcId).notifier)
                    .autoArrange();
              },
          ),
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            tooltip: 'Auto-arrange',
            onPressed: () => ref
                .read(dialogueGraphProvider(widget.npcId).notifier)
                .autoArrange(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'addNode',
            tooltip: 'Add node',
            onPressed: () => _addNode(context),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'playback',
            tooltip: 'Play from start',
            onPressed: (graphAsync.valueOrNull?.nodes.isNotEmpty ?? false)
                ? () => context.goNamed('playback',
                    pathParameters: {'id': widget.npcId})
                : null,
            child: const Icon(Icons.play_arrow_rounded),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (graphAsync.hasError && !graphAsync.hasValue) {
          return Center(child: Text('Error: ${graphAsync.error}'));
        }
        final graph = graphAsync.valueOrNull;
        if (graph == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (graph.nodes.isEmpty) {
          return GsEmptyState(
            message: 'No nodes yet.\nTap + to add the first dialogue node.',
            icon: Icons.chat_bubble_outline,
            action: FilledButton.icon(
              onPressed: () => _addNode(context),
              icon: const Icon(Icons.add),
              label: const Text('Add node'),
            ),
          );
        }
        return _buildGraph(context, graph, direction);
      }),
    );
  }

  Widget _buildGraph(BuildContext context, DialogueGraphState graph,
      Axis direction) {
    final nodeRects = <String, Rect>{};
    for (final node in graph.nodes) {
      final delta = _localOffsets[node.id] ?? Offset.zero;
      final pos = Offset(node.layoutX, node.layoutY) + delta;
      nodeRects[node.id] =
          Rect.fromLTWH(pos.dx, pos.dy, NodeCard.kWidth, NodeCard.kHeight);
    }

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(500),
      minScale: 0.25,
      maxScale: 3.0,
      child: SizedBox(
        width: 3000,
        height: 3000,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: NodeConnectionPainter(
                  nodeRects: nodeRects,
                  choices: graph.choices,
                  direction: direction,
                  strokeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ...graph.nodes.map((node) {
              final rect = nodeRects[node.id]!;
              final choiceCount = graph.choices
                  .where((c) => c.fromNodeId == node.id)
                  .length;
              return Positioned(
                left: rect.left,
                top: rect.top,
                child: GsAnimatedCard(
                  key: ValueKey(node.id),
                  isExiting: _exitingIds.contains(node.id),
                  duration: _animationDuration,
                  onExitComplete: () {
                    setState(() => _exitingIds.remove(node.id));
                  },
                  child: NodeCard(
                    node: node,
                    choiceCount: choiceCount,
                    onDragUpdate: (delta) => setState(() {
                      _localOffsets[node.id] =
                          (_localOffsets[node.id] ?? Offset.zero) + delta;
                    }),
                    onDragEnd: () {
                      final total = _localOffsets[node.id] ?? Offset.zero;
                      ref
                          .read(dialogueGraphProvider(widget.npcId).notifier)
                          .moveNode(
                            node.id,
                            node.layoutX + total.dx,
                            node.layoutY + total.dy,
                          );
                      setState(() => _localOffsets.remove(node.id));
                    },
                    onEdit: () => _showEditSheet(context, node, graph),
                    onSetStart: () => ref
                        .read(dialogueGraphProvider(widget.npcId).notifier)
                        .setStart(node.id),
                    onDelete: () => _confirmDelete(context, node),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _addNode(BuildContext context) async {
    final speakerCtrl = TextEditingController();
    final textCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Text('New Node'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GsTextField(
                  controller: speakerCtrl,
                  label: 'Speaker',
                  hint: 'e.g. Village Elder',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                GsTextField(
                  controller: textCtrl,
                  label: 'Dialogue text',
                  hint: 'What does the character say?',
                  maxLines: 3,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setDialogState(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: textCtrl.text.trim().isNotEmpty
                    ? () => Navigator.of(ctx).pop(true)
                    : null,
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );

    final speaker = speakerCtrl.text.trim();
    final text = textCtrl.text.trim();
    speakerCtrl.dispose();
    textCtrl.dispose();

    if (confirmed != true || text.isEmpty) return;

    final graph = ref.read(dialogueGraphProvider(widget.npcId)).valueOrNull;
    double x = 100;
    double y = 100;
    if (graph != null && graph.nodes.isNotEmpty) {
      final last = graph.nodes.last;
      x = last.layoutX;
      y = last.layoutY + NodeCard.kHeight + 60;
    }

    await ref
        .read(dialogueGraphProvider(widget.npcId).notifier)
        .addNode(
          layoutX: x,
          layoutY: y,
          speakerName: speaker,
          dialogueText: text,
        );
  }

  Future<void> _showEditSheet(
      BuildContext context, DialogueNode node, DialogueGraphState graph) {
    final nodeChoices =
        graph.choices.where((c) => c.fromNodeId == node.id).toList();
    return NodeEditSheet.show(
      context,
      node: node,
      choices: nodeChoices,
      npcId: widget.npcId,
      allNodes: graph.nodes,
    );
  }

  Future<void> _confirmDelete(BuildContext context, DialogueNode node) async {
    final label =
        node.speakerName.isEmpty ? 'this node' : '"${node.speakerName}"';
    final confirmed = await GsDialog.show(
      context: context,
      title: 'Delete node',
      confirmLabel: 'Delete',
      isDestructive: true,
      content: Text(
          'Delete $label? Inbound choices will be disconnected.'),
    );
    if (confirmed == true) {
      setState(() => _exitingIds.add(node.id));
      await Future<void>.delayed(_animationDuration);
      if (!mounted) return;
      await ref
          .read(dialogueGraphProvider(widget.npcId).notifier)
          .deleteNode(node.id);
    }
  }
}
