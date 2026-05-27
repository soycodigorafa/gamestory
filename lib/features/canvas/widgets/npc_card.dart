import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class NpcCard extends StatelessWidget {
  const NpcCard({
    super.key,
    required this.name,
    required this.colorHex,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final String name;
  final String colorHex;
  final void Function(Offset delta) onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Color get _accentColor {
    try {
      final hex = colorHex.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.darkPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

    return GestureDetector(
      onPanUpdate: (details) => onDragUpdate(details.delta),
      onPanEnd: (_) => onDragEnd(),
      onTap: onTap,
      onLongPressStart: (details) => _showContextMenu(context, details.globalPosition),
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: _accentColor.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _accentColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset globalPosition) async {
    final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    final result = await showMenu<_NpcAction>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem(value: _NpcAction.edit, child: Text('Edit')),
        PopupMenuItem(value: _NpcAction.delete, child: Text('Delete')),
      ],
    );
    if (result == _NpcAction.edit) onEdit();
    if (result == _NpcAction.delete) onDelete();
  }
}

enum _NpcAction { edit, delete }
