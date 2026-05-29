import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../canvas/providers/npc_list_provider.dart';
import '../../dialogue_editor/providers/dialogue_graph_provider.dart';
import '../../projects/providers/project_list_provider.dart';
import '../services/gsp_import_service.dart';

part 'import_provider.g.dart';

@riverpod
class Import extends _$Import {
  @override
  Future<void> build() async {}

  Future<GspImportResult?> importFromFile() async {
    state = const AsyncLoading();
    GspImportResult? result;
    state = await AsyncValue.guard(() async {
      final service = GspImportService(
        projectRepo: ref.read(projectRepositoryProvider),
        npcRepo: ref.read(npcRepositoryProvider),
        nodeRepo: ref.read(dialogueNodeRepositoryProvider),
        choiceRepo: ref.read(dialogueChoiceRepositoryProvider),
        reqFlagRepo: ref.read(requirementFlagRepositoryProvider),
        rewFlagRepo: ref.read(rewardFlagRepositoryProvider),
      );
      result = await service.importFromFile();
    });
    return result;
  }
}
