import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/requirement_flag.dart';
import '../../../domain/entities/reward_flag.dart';
import '../../canvas/providers/npc_list_provider.dart';
import '../../dialogue_editor/providers/dialogue_graph_provider.dart';
import '../../projects/providers/project_list_provider.dart';
import '../services/gsp_export_service.dart';
import 'project_dirty_provider.dart';

part 'auto_save_provider.g.dart';

@Riverpod(keepAlive: true)
class ProjectAutoSave extends _$ProjectAutoSave {
  Timer? _debounce;

  @override
  Future<void> build() async {
    ref.onDispose(() => _debounce?.cancel());

    final project = ref.watch(currentProjectProvider);
    if (project?.filePath == null) return;

    ref.watch(projectDirtyProvider);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), _flush);
  }

  Future<void> _flush() async {
    final project = ref.read(currentProjectProvider);
    if (project?.filePath == null) return;

    try {
      final npcs = await ref.read(npcListProvider.future);
      final npcsData = <NpcGraphData>[];

      for (final npc in npcs) {
        final graph = await ref.read(dialogueGraphProvider(npc.id).future);
        final choiceIds = graph.choices.map((c) => c.id).toList();
        final nodeIds = graph.nodes.map((n) => n.id).toList();

        final reqFlags = choiceIds.isEmpty
            ? <RequirementFlag>[]
            : await ref
                .read(requirementFlagRepositoryProvider)
                .getByChoiceIds(choiceIds);

        final rewFlags = nodeIds.isEmpty
            ? <RewardFlag>[]
            : await ref
                .read(rewardFlagRepositoryProvider)
                .getByNodeIds(nodeIds);

        npcsData.add(NpcGraphData(
          npc: npc,
          nodes: graph.nodes,
          choices: graph.choices,
          requirementFlags: reqFlags,
          rewardFlags: rewFlags,
        ));
      }

      const service = GspExportService();
      await service.saveToPath(project!.filePath!, project, npcsData);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
