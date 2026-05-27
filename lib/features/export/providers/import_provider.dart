import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../canvas/providers/npc_list_provider.dart';
import '../../dialogue_editor/providers/dialogue_graph_provider.dart';
import '../services/import_service.dart';

part 'import_provider.g.dart';

@riverpod
class Import extends _$Import {
  @override
  Future<void> build() async {}

  Future<ImportResult?> importFromFile() async {
    state = const AsyncLoading();
    ImportResult? result;
    state = await AsyncValue.guard(() async {
      final service = ImportService(
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
