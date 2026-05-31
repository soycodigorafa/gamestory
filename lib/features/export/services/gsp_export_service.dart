import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../domain/entities/dialogue_choice.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../domain/entities/npc.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/requirement_flag.dart';
import '../../../domain/entities/reward_flag.dart';

class NpcGraphData {
  const NpcGraphData({
    required this.npc,
    required this.nodes,
    required this.choices,
    required this.requirementFlags,
    required this.rewardFlags,
  });

  final Npc npc;
  final List<DialogueNode> nodes;
  final List<DialogueChoice> choices;
  final List<RequirementFlag> requirementFlags;
  final List<RewardFlag> rewardFlags;
}

class GspExportService {
  const GspExportService();

  Future<void> exportGsp(
    Project project,
    List<NpcGraphData> npcsData,
  ) async {
    final map = buildGspMap(project, npcsData);
    const encoder = JsonEncoder.withIndent('  ');
    final json = encoder.convert(map);
    final fileName = '${_sanitize(project.name)}.gsp';
    await _shareText(json, fileName);
  }

  Future<void> saveToPath(
    String path,
    Project project,
    List<NpcGraphData> npcsData,
  ) async {
    const encoder = JsonEncoder.withIndent('  ');
    final json = encoder.convert(buildGspMap(project, npcsData));
    await File(path).writeAsString(json, encoding: utf8);
  }

  Map<String, dynamic> buildGspMap(
    Project project,
    List<NpcGraphData> npcsData,
  ) {
    return {
      'schemaVersion': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'project': {
        'name': project.name,
        'description': project.description,
      },
      'npcs': npcsData.map((data) => _serializeNpc(data)).toList(),
    };
  }

  Map<String, dynamic> _serializeNpc(NpcGraphData data) {
    return {
      'id': data.npc.id,
      'name': data.npc.name,
      'description': data.npc.description,
      'colorHex': data.npc.colorHex,
      'canvasX': data.npc.canvasX,
      'canvasY': data.npc.canvasY,
      'nodes': data.nodes
          .map((n) => {
                'id': n.id,
                'speakerName': n.speakerName,
                'dialogueText': n.dialogueText,
                'isStart': n.isStart,
                'layoutX': n.layoutX,
                'layoutY': n.layoutY,
              })
          .toList(),
      'choices': data.choices
          .map((c) => {
                'id': c.id,
                'fromNodeId': c.fromNodeId,
                'toNodeId': c.toNodeId,
                'choiceText': c.choiceText,
                'sortOrder': c.sortOrder,
              })
          .toList(),
      'requirementFlags': data.requirementFlags
          .map((f) => {
                'id': f.id,
                'choiceId': f.choiceId,
                'flagName': f.flagName,
                'requiredValue': f.requiredValue,
              })
          .toList(),
      'rewardFlags': data.rewardFlags
          .map((f) => {
                'id': f.id,
                'nodeId': f.nodeId,
                'flagName': f.flagName,
                'setValue': f.setValue,
              })
          .toList(),
    };
  }

  String _sanitize(String name) =>
      name.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(' ', '_');

  Future<void> _shareText(String content, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(content, encoding: utf8);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      fileNameOverrides: [fileName],
    );
  }
}
