import 'package:flutter/material.dart';

import '../../../domain/entities/dialogue_node.dart';

class NodePickerModal {
  static Future<String?> show(
    BuildContext context, {
    required List<DialogueNode> allNodes,
    required String currentNodeId,
    String? selectedNodeId,
  }) {
    final available =
        allNodes.where((n) => n.id != currentNodeId).toList();

    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Connect to node'),
        content: available.isEmpty
            ? const Text(
                'No other nodes available. Add more nodes first.',
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            : SizedBox(
                width: 320,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: available.length,
                  itemBuilder: (ctx, i) {
                    final node = available[i];
                    final isSelected = node.id == selectedNodeId;
                    return ListTile(
                      selected: isSelected,
                      leading: Icon(
                        node.isStart
                            ? Icons.star_rounded
                            : Icons.chat_bubble_outline,
                        size: 20,
                      ),
                      title: Text(
                        node.speakerName.isEmpty ? 'Unnamed' : node.speakerName,
                        style: const TextStyle(fontSize: 13),
                      ),
                      subtitle: node.dialogueText.isNotEmpty
                          ? Text(
                              node.dialogueText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11),
                            )
                          : null,
                      onTap: () => Navigator.of(ctx).pop(node.id),
                    );
                  },
                ),
              ),
        actions: [
          if (selectedNodeId != null)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(''),
              child: const Text('Disconnect'),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
