import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/project.dart';
import '../../../shared/widgets/gs_dialog.dart';
import '../../../shared/widgets/gs_empty_state.dart';
import '../../../shared/widgets/gs_text_field.dart';
import '../../export/providers/import_provider.dart';
import '../providers/project_list_provider.dart';
import '../providers/project_startup_provider.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(projectStartupProvider, (_, next) {
      next.whenData((result) {
        if (result.removedProjectNames.isNotEmpty && context.mounted) {
          final names = result.removedProjectNames.join(', ');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${result.removedProjectNames.length} project(s) with missing files were removed: $names',
              ),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      });
    });

    final projectsAsync = ref.watch(projectListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GameStory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_outlined),
            tooltip: 'Import project (.gsp)',
            onPressed: () => _importProject(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.pushNamed('settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New project',
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: projectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (projects) {
          if (projects.isEmpty) {
            return GsEmptyState(
              message: 'No projects yet.\nTap + to create your first project.',
              icon: Icons.folder_outlined,
              action: FilledButton.icon(
                onPressed: () => _showCreateDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('New Project'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: projects.length,
            itemBuilder: (context, index) =>
                _ProjectCard(project: projects[index]),
          );
        },
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final confirmed = await GsDialog.show(
      context: context,
      title: 'New Project',
      confirmLabel: 'Create',
      content: GsTextField(
        controller: controller,
        label: 'Name',
        hint: 'e.g. Fantasy RPG',
        autofocus: true,
        textInputAction: TextInputAction.done,
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await ref
          .read(projectListProvider.notifier)
          .createProject(controller.text.trim());
    }
    controller.dispose();
  }

  Future<void> _importProject(BuildContext context, WidgetRef ref) async {
    final result =
        await ref.read(importProvider.notifier).importFromFile();
    if (!context.mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported "${result.project.name}" (${result.npcCount} NPCs)',
          ),
        ),
      );
    } else {
      final importState = ref.read(importProvider);
      if (importState.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: ${importState.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _ProjectCard extends ConsumerWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final primary =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            ref.read(currentProjectProvider.notifier).set(project);
            context.goNamed('canvas');
          },
          onLongPress: () => _showMenu(context, ref),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.folder_rounded,
                  size: 20,
                  color: primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    project.name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, color: mutedColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMenu(BuildContext context, WidgetRef ref) async {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height + 8,
      ),
      items: const [
        PopupMenuItem(value: 'rename', child: Text('Rename')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );

    if (!context.mounted) return;
    if (result == 'rename') {
      await _showRenameDialog(context, ref);
    } else if (result == 'delete') {
      await _confirmDelete(context, ref);
    }
  }

  Future<void> _showRenameDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: project.name);
    final confirmed = await GsDialog.show(
      context: context,
      title: 'Rename Project',
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
          .read(projectListProvider.notifier)
          .renameProject(project.id, controller.text.trim());
    }
    controller.dispose();
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await GsDialog.show(
      context: context,
      title: 'Delete Project',
      confirmLabel: 'Delete',
      isDestructive: true,
      content: Text(
          'Delete "${project.name}"? All NPCs and dialogues will be lost. This cannot be undone.'),
    );
    if (confirmed == true) {
      await ref
          .read(projectListProvider.notifier)
          .deleteProject(project.id);
    }
  }
}
