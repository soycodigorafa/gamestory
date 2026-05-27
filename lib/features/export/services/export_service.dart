import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../domain/entities/dialogue_choice.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../domain/entities/npc.dart';
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

class ExportService {
  const ExportService();

  Future<void> exportJson(NpcGraphData data) async {
    final json = _buildJson(data);
    final fileName = '${_sanitize(data.npc.name)}.gamestory.json';
    await _shareText(json, fileName, mimeType: 'application/json');
  }

  Future<void> exportCsv(NpcGraphData data) async {
    final csv = _buildCsv(data);
    final fileName = '${_sanitize(data.npc.name)}.csv';
    await _shareText(csv, fileName, mimeType: 'text/csv');
  }

  Map<String, dynamic> buildJsonMap(NpcGraphData data) => _buildJsonMap(data);

  Map<String, dynamic> _buildJsonMap(NpcGraphData data) {
    return {
      'version': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'npc': {
        'id': data.npc.id,
        'name': data.npc.name,
        'description': data.npc.description,
        'colorHex': data.npc.colorHex,
        'canvasX': data.npc.canvasX,
        'canvasY': data.npc.canvasY,
      },
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

  String _buildJson(NpcGraphData data) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(_buildJsonMap(data));
  }

  String _buildCsv(NpcGraphData data) {
    final reqByChoice = <String, List<RequirementFlag>>{};
    for (final f in data.requirementFlags) {
      reqByChoice.putIfAbsent(f.choiceId, () => []).add(f);
    }
    final rewByNode = <String, List<RewardFlag>>{};
    for (final f in data.rewardFlags) {
      rewByNode.putIfAbsent(f.nodeId, () => []).add(f);
    }

    final buf = StringBuffer();
    buf.writeln(
      'nodeId,speakerName,dialogueText,isStart,'
      'choiceId,choiceText,toNodeId,sortOrder,'
      'requirementFlags,rewardFlags',
    );

    for (final node in data.nodes) {
      final nodeChoices =
          data.choices.where((c) => c.fromNodeId == node.id).toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      final rewCell = _rewardCell(rewByNode[node.id] ?? []);

      if (nodeChoices.isEmpty) {
        buf.writeln(
          '${_csvCell(node.id)},${_csvCell(node.speakerName)},'
          '${_csvCell(node.dialogueText)},${node.isStart},'
          ',,,,,$rewCell',
        );
      } else {
        for (final choice in nodeChoices) {
          final reqCell = _requirementCell(reqByChoice[choice.id] ?? []);
          buf.writeln(
            '${_csvCell(node.id)},${_csvCell(node.speakerName)},'
            '${_csvCell(node.dialogueText)},${node.isStart},'
            '${_csvCell(choice.id)},${_csvCell(choice.choiceText)},'
            '${_csvCell(choice.toNodeId ?? "")},'
            '${choice.sortOrder},$reqCell,$rewCell',
          );
        }
      }
    }

    return buf.toString();
  }

  String _rewardCell(List<RewardFlag> flags) {
    if (flags.isEmpty) return '';
    return _csvCell(flags.map((f) => '${f.flagName}=${f.setValue}').join(';'));
  }

  String _requirementCell(List<RequirementFlag> flags) {
    if (flags.isEmpty) return '';
    return _csvCell(flags.map((f) => '${f.flagName}=${f.requiredValue}').join(';'));
  }

  String _csvCell(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String _sanitize(String name) =>
      name.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(' ', '_');

  Future<void> _shareText(
    String content,
    String fileName, {
    required String mimeType,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(content, encoding: utf8);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: mimeType)],
      fileNameOverrides: [fileName],
    );
  }
}
