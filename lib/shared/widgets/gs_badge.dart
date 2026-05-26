import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum GsBadgeStatus { complete, incomplete, locked }

class GsBadge extends StatelessWidget {
  const GsBadge({
    super.key,
    required this.status,
    this.label,
  });

  final GsBadgeStatus status;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final (color, icon, defaultLabel) = switch (status) {
      GsBadgeStatus.complete => (
          AppColors.secondary,
          Icons.check_circle_outline,
          'Complete',
        ),
      GsBadgeStatus.incomplete => (
          AppColors.muted,
          Icons.radio_button_unchecked,
          'Incomplete',
        ),
      GsBadgeStatus.locked => (
          AppColors.error,
          Icons.lock_outline,
          'Locked',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label ?? defaultLabel,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
