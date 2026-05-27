import 'dart:convert';

import 'package:file_picker/file_picker.dart';

import '../../../domain/entities/dialogue_choice.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../domain/entities/npc.dart';
import '../../../domain/entities/requirement_flag.dart';
import '../../../domain/entities/reward_flag.dart';
import '../../../domain/repositories/dialogue_choice_repository.dart';
import '../../../domain/repositories/dialogue_node_repository.dart';
import '../../../domain/repositories/npc_repository.dart';
import '../../../domain/repositories/requirement_flag_repository.dart';
import '../../../domain/repositories/reward_flag_repository.dart';

class ImportResult {
  const ImportResult({required this.npc, required this.nodeCount});

  final Npc npc;
  final int nodeCount;
}

class ImportService {
  ImportService({
    required this._npcRepo,
    required this._nodeRepo,
    required this._choiceRepo,
    required this._reqFlagRepo,
    required this._rewFlagRepo,
  });

  final NpcRepository _npcRepo;
  final DialogueNodeRepository _nodeRepo;
  final DialogueChoiceRepository _choiceRepo;
  final RequirementFlagRepository _reqFlagRepo;
  final RewardFlagRepository _rewFlagRepo;

  Future<ImportResult?> importFromFile() async {
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

  Future<ImportResult> importFromMap(Map<String, dynamic> map) =>
      _importFromMap(map);

  Future<ImportResult> _importFromMap(Map<String, dynamic> map) async {
    final version = map['version'] as int?;
    if (version != 1) {
      throw FormatException(
        'Unsupported export version: $version. Expected 1.',
      );
    }

    final npcMap = map['npc'] as Map<String, dynamic>;
    final nodesRaw = (map['nodes'] as List<dynamic>?) ?? [];
    final choicesRaw = (map['choices'] as List<dynamic>?) ?? [];
    final reqFlagsRaw = (map['requirementFlags'] as List<dynamic>?) ?? [];
    final rewFlagsRaw = (map['rewardFlags'] as List<dynamic>?) ?? [];

    final nodeIdMap = <String, String>{};
    final choiceIdMap = <String, String>{};

    final npc = await _npcRepo.create(CreateNpcInput(
      name: npcMap['name'] as String,
      description: (npcMap['description'] as String?) ?? '',
      canvasX: (npcMap['canvasX'] as num?)?.toDouble() ?? 0,
      canvasY: (npcMap['canvasY'] as num?)?.toDouble() ?? 0,
      colorHex: (npcMap['colorHex'] as String?) ?? '#7B61FF',
    ));

    for (final raw in nodesRaw) {
      final n = raw as Map<String, dynamic>;
      final oldId = n['id'] as String;
      final node = await _nodeRepo.create(CreateNodeInput(
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
      final choice = await _choiceRepo.create(CreateChoiceInput(
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
      await _reqFlagRepo.create(CreateRequirementFlagInput(
        choiceId: choiceIdMap[oldChoiceId] ?? oldChoiceId,
        flagName: f['flagName'] as String,
        requiredValue: (f['requiredValue'] as bool?) ?? true,
      ));
    }

    for (final raw in rewFlagsRaw) {
      final f = raw as Map<String, dynamic>;
      final oldNodeId = f['nodeId'] as String;
      await _rewFlagRepo.create(CreateRewardFlagInput(
        nodeId: nodeIdMap[oldNodeId] ?? oldNodeId,
        flagName: f['flagName'] as String,
        setValue: (f['setValue'] as bool?) ?? true,
      ));
    }

    return ImportResult(npc: npc, nodeCount: nodesRaw.length);
  }
}
