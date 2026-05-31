import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/npc.dart';
import '../../../features/export/providers/auto_save_provider.dart';
import '../../../features/export/providers/export_provider.dart';
import '../../../features/projects/providers/project_list_provider.dart';
import '../../../shared/widgets/gs_animated_card.dart';
import '../../../shared/widgets/gs_dialog.dart';
import '../../../shared/widgets/gs_empty_state.dart';
import '../../../shared/widgets/gs_text_field.dart';
import '../providers/npc_list_provider.dart';
import '../widgets/npc_card.dart';

class CanvasScreen extends ConsumerStatefulWidget {
  const CanvasScreen({super.key});

  @override
  ConsumerState<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends ConsumerState<CanvasScreen> {
  final Map<String, Offset> _localOffsets = {};
  final _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(projectAutoSaveProvider);
    ref.listen<AsyncValue<void>>(projectAutoSaveProvider, (_, next) {
      if (next.hasError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Auto-save failed: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final npcAsync = ref.watch(npcListProvider);
    final project = ref.watch(currentProjectProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Projects',
          onPressed: () => context.goNamed('projects'),
        ),
        title: Text(project?.name ?? 'Canvas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_outlined),
            tooltip: 'Export project as .gsp',
            onPressed: () => _exportProject(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.pushNamed('settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add NPC',
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
      body: npcAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (npcs) {
          if (npcs.isEmpty) {
            return GsEmptyState(
              message: 'No NPCs yet.\nTap + to create your first character.',
              icon: Icons.person_outline,
              action: FilledButton.icon(
                onPressed: () => _showCreateDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add NPC'),
              ),
            );
          }
          return _buildCanvas(npcs);
        },
      ),
    );
  }

  Widget _buildCanvas(List<Npc> npcs) {
    return InteractiveViewer(
      transformationController: _transformationController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(500),
      minScale: 0.3,
      maxScale: 3.0,
      child: SizedBox(
        width: 3000,
        height: 3000,
        child: Stack(
          children: npcs.map((npc) {
            final base = Offset(npc.canvasX, npc.canvasY);
            final delta = _localOffsets[npc.id] ?? Offset.zero;
            final pos = base + delta;
            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: GsAnimatedCard(
                key: ValueKey(npc.id),
                child: NpcCard(
                  name: npc.name,
                  colorHex: npc.colorHex,
                  onDragUpdate: (d) =>
                      setState(() => _localOffsets[npc.id] =
                          (_localOffsets[npc.id] ?? Offset.zero) + d),
                  onDragEnd: () {
                    final total = _localOffsets[npc.id] ?? Offset.zero;
                    final newX = npc.canvasX + total.dx;
                    final newY = npc.canvasY + total.dy;
                    ref
                        .read(npcListProvider.notifier)
                        .moveNpc(npc.id, newX, newY);
                    setState(() => _localOffsets.remove(npc.id));
                  },
                  onTap: () => context.goNamed(
                    'dialogue-editor',
                    pathParameters: {'id': npc.id},
                  ),
                  onEdit: () => _showEditDialog(context, npc),
                  onDelete: () => _confirmDelete(context, npc),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final mq = MediaQuery.of(context);
    final appBarHeight = kToolbarHeight + mq.padding.top;
    final viewportCenter = Offset(
      mq.size.width / 2,
      (mq.size.height - appBarHeight) / 2,
    );
    final canvasPos = _transformationController.toScene(viewportCenter);

    final controller = TextEditingController();
    final confirmed = await GsDialog.show(
      context: context,
      title: 'New NPC',
      confirmLabel: 'Create',
      content: GsTextField(
        controller: controller,
        label: 'Name',
        hint: 'e.g. Village Elder',
        autofocus: true,
        textInputAction: TextInputAction.done,
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await ref
          .read(npcListProvider.notifier)
          .createNpc(
            controller.text.trim(),
            canvasX: canvasPos.dx,
            canvasY: canvasPos.dy,
          );
    }
    controller.dispose();
  }

  Future<void> _showEditDialog(BuildContext context, Npc npc) async {
    final controller = TextEditingController(text: npc.name);
    final confirmed = await GsDialog.show(
      context: context,
      title: 'Rename NPC',
      confirmLabel: 'Save',
      content: GsTextField(
        controller: controller,
        label: 'Name',
        autofocus: true,
        textInputAction: TextInputAction.done,
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await ref
          .read(npcListProvider.notifier)
          .renameNpc(npc.id, controller.text.trim());
    }
    controller.dispose();
  }

  Future<void> _exportProject(BuildContext context) async {
    final project = ref.read(currentProjectProvider);
    if (project == null) return;
    await ref.read(exportProvider.notifier).exportGsp(project.id);
    final exportState = ref.read(exportProvider);
    if (!context.mounted) return;
    if (exportState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: ${exportState.error}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, Npc npc) async {
    final confirmed = await GsDialog.show(
      context: context,
      title: 'Delete NPC',
      confirmLabel: 'Delete',
      isDestructive: true,
      content: Text('Delete "${npc.name}"? This cannot be undone.'),
    );
    if (confirmed == true) {
      await ref.read(npcListProvider.notifier).deleteNpc(npc.id);
    }
  }
}
