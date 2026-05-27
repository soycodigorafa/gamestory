import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/dialogue_node.dart';

class NodeCard extends StatelessWidget {
  const NodeCard({
    super.key,
    required this.node,
    required this.choiceCount,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onEdit,
    required this.onSetStart,
    required this.onDelete,
  });

  static const double kWidth = 200.0;
  static const double kHeight = 110.0;

  final DialogueNode node;
  final int choiceCount;
  final void Function(Offset delta) onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback onEdit;
  final VoidCallback onSetStart;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.lightSurfaceVariant;
    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return GestureDetector(
      onPanUpdate: (details) => onDragUpdate(details.delta),
      onPanEnd: (_) => onDragEnd(),
      onTap: onEdit,
      onLongPressStart: (details) =>
          _showContextMenu(context, details.globalPosition),
      child: Container(
        width: kWidth,
        height: kHeight,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: node.isStart ? primary : borderColor,
            width: node.isStart ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(11),
                ),
              ),
              child: Row(
                children: [
                  if (node.isStart) ...[
                    Icon(Icons.star_rounded, size: 12, color: primary),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      node.speakerName.isEmpty ? 'Unnamed' : node.speakerName,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  node.dialogueText.isEmpty
                      ? 'No dialogue text'
                      : node.dialogueText,
                  style: TextStyle(
                    color: node.dialogueText.isEmpty ? mutedColor : textColor,
                    fontSize: 11,
                    height: 1.4,
                    fontStyle: node.dialogueText.isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (choiceCount > 0)
              Padding(
                padding:
                    const EdgeInsets.only(left: 10, right: 10, bottom: 6),
                child: Text(
                  '$choiceCount choice${choiceCount == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset globalPosition) async {
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final result = await showMenu<_NodeAction>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(value: _NodeAction.edit, child: Text('Edit')),
        if (!node.isStart)
          const PopupMenuItem(
            value: _NodeAction.setStart,
            child: Text('Set as Start'),
          ),
        const PopupMenuItem(
          value: _NodeAction.delete,
          child: Text('Delete'),
        ),
      ],
    );
    if (result == _NodeAction.edit) onEdit();
    if (result == _NodeAction.setStart) onSetStart();
    if (result == _NodeAction.delete) onDelete();
  }
}

enum _NodeAction { edit, setStart, delete }
