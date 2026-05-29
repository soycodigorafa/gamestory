import 'dart:convert';

import 'package:file_picker/file_picker.dart';

import '../../../domain/entities/dialogue_choice.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../domain/entities/npc.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/requirement_flag.dart';
import '../../../domain/entities/reward_flag.dart';
import '../../../domain/repositories/dialogue_choice_repository.dart';
import '../../../domain/repositories/dialogue_node_repository.dart';
import '../../../domain/repositories/npc_repository.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/repositories/requirement_flag_repository.dart';
import '../../../domain/repositories/reward_flag_repository.dart';

class GspImportResult {
  const GspImportResult({required this.project, required this.npcCount});

  final Project project;
  final int npcCount;
}

class GspImportService {
  GspImportService({
    required this.projectRepo,
    required this.npcRepo,
    required this.nodeRepo,
    required this.choiceRepo,
    required this.reqFlagRepo,
    required this.rewFlagRepo,
  });

  final ProjectRepository projectRepo;
  final NpcRepository npcRepo;
  final DialogueNodeRepository nodeRepo;
  final DialogueChoiceRepository choiceRepo;
  final RequirementFlagRepository reqFlagRepo;
  final RewardFlagRepository rewFlagRepo;

  Future<GspImportResult?> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return null;

    final jsonString = utf8.decode(bytes);
    final map = jsonDecode(jsonString) as Map<String, dynamic>;

    return _importFromMap(map);
  }

  Future<GspImportResult> importFromMap(Map<String, dynamic> map) =>
      _importFromMap(map);

  Future<GspImportResult> _importFromMap(Map<String, dynamic> map) async {
    final schemaVersion = map['schemaVersion'] as int?;
    if (schemaVersion != 1) {
      throw FormatException(
        'Unsupported .gsp schema version: $schemaVersion. Expected 1.',
      );
    }

    final projectMap = map['project'] as Map<String, dynamic>;
    final npcsRaw = (map['npcs'] as List<dynamic>?) ?? [];

    final project = await projectRepo.create(CreateProjectInput(
      name: projectMap['name'] as String,
      description: (projectMap['description'] as String?) ?? '',
    ));

    for (final npcRaw in npcsRaw) {
      await _importNpc(npcRaw as Map<String, dynamic>, project.id);
    }

    return GspImportResult(project: project, npcCount: npcsRaw.length);
  }

  Future<void> _importNpc(
    Map<String, dynamic> npcMap,
    String projectId,
  ) async {
    final nodesRaw = (npcMap['nodes'] as List<dynamic>?) ?? [];
    final choicesRaw = (npcMap['choices'] as List<dynamic>?) ?? [];
    final reqFlagsRaw = (npcMap['requirementFlags'] as List<dynamic>?) ?? [];
    final rewFlagsRaw = (npcMap['rewardFlags'] as List<dynamic>?) ?? [];

    final npc = await npcRepo.create(CreateNpcInput(
      name: npcMap['name'] as String,
      projectId: projectId,
      description: (npcMap['description'] as String?) ?? '',
      canvasX: (npcMap['canvasX'] as num?)?.toDouble() ?? 0,
      canvasY: (npcMap['canvasY'] as num?)?.toDouble() ?? 0,
      colorHex: (npcMap['colorHex'] as String?) ?? '#7B61FF',
    ));

    final nodeIdMap = <String, String>{};
    final choiceIdMap = <String, String>{};

    for (final raw in nodesRaw) {
      final n = raw as Map<String, dynamic>;
      final oldId = n['id'] as String;
      final node = await nodeRepo.create(CreateNodeInput(
        npcId: npc.id,
        speakerName: (n['speakerName'] as String?) ?? '',
        dialogueText: (n['dialogueText'] as String?) ?? '',
        isStart: (n['isStart'] as bool?) ?? false,
        layoutX: (n['layoutX'] as num?)?.toDouble() ?? 0,
        layoutY: (n['layoutY'] as num?)?.toDouble() ?? 0,
      ));
      nodeIdMap[oldId] = node.id;
    }

    for (final raw in choicesRaw) {
      final c = raw as Map<String, dynamic>;
      final oldId = c['id'] as String;
      final oldFromNodeId = c['fromNodeId'] as String;
      final oldToNodeId = c['toNodeId'] as String?;
      final choice = await choiceRepo.create(CreateChoiceInput(
        fromNodeId: nodeIdMap[oldFromNodeId] ?? oldFromNodeId,
        toNodeId: oldToNodeId != null ? nodeIdMap[oldToNodeId] : null,
        choiceText: (c['choiceText'] as String?) ?? '',
        sortOrder: (c['sortOrder'] as int?) ?? 0,
      ));
      choiceIdMap[oldId] = choice.id;
    }

    for (final raw in reqFlagsRaw) {
      final f = raw as Map<String, dynamic>;
      final oldChoiceId = f['choiceId'] as String;
      await reqFlagRepo.create(CreateRequirementFlagInput(
        choiceId: choiceIdMap[oldChoiceId] ?? oldChoiceId,
        flagName: f['flagName'] as String,
        requiredValue: (f['requiredValue'] as bool?) ?? true,
      ));
    }

    for (final raw in rewFlagsRaw) {
      final f = raw as Map<String, dynamic>;
      final oldNodeId = f['nodeId'] as String;
      await rewFlagRepo.create(CreateRewardFlagInput(
        nodeId: nodeIdMap[oldNodeId] ?? oldNodeId,
        flagName: f['flagName'] as String,
        setValue: (f['setValue'] as bool?) ?? true,
      ));
    }
  }
}
