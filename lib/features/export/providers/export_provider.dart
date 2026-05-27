import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/requirement_flag.dart';
import '../../../domain/entities/reward_flag.dart';
import '../../canvas/providers/npc_list_provider.dart';
import '../../dialogue_editor/providers/dialogue_graph_provider.dart';
import '../services/export_service.dart';

part 'export_provider.g.dart';

@riverpod
class Export extends _$Export {
  @override
  Future<void> build() async {}

  Future<void> exportJson(String npcId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _doExport(npcId, json: true));
  }

  Future<void> exportCsv(String npcId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _doExport(npcId, json: false));
  }

  Future<void> _doExport(String npcId, {required bool json}) async {
    final npcs = await ref.read(npcListProvider.future);
    final npc = npcs.firstWhere((n) => n.id == npcId);

    final graph = await ref.read(dialogueGraphProvider(npcId).future);
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

    final data = NpcGraphData(
      npc: npc,
      nodes: graph.nodes,
      choices: graph.choices,
      requirementFlags: reqFlags,
      rewardFlags: rewFlags,
    );

    const service = ExportService();
    if (json) {
      await service.exportJson(data);
    } else {
      await service.exportCsv(data);
    }
  }
}
