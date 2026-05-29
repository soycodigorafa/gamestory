import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/requirement_flag.dart';
import '../../../domain/entities/reward_flag.dart';
import '../../canvas/providers/npc_list_provider.dart';
import '../../dialogue_editor/providers/dialogue_graph_provider.dart';
import '../../projects/providers/project_list_provider.dart';
import '../services/gsp_export_service.dart';

part 'export_provider.g.dart';

@riverpod
class Export extends _$Export {
  @override
  Future<void> build() async {}

  Future<void> exportGsp(String projectId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _doExportGsp(projectId));
  }

  Future<void> _doExportGsp(String projectId) async {
    final project = await ref
        .read(projectRepositoryProvider)
        .watchAll()
        .first
        .then((list) => list.firstWhere((p) => p.id == projectId));

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
    await service.exportGsp(project, npcsData);
  }
}
