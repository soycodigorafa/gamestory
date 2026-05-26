import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class GsProgressBar extends StatelessWidget {
  const GsProgressBar({
    super.key,
    required this.progress,
    this.label,
    this.milestoneThresholds = const [],
    this.height = 8.0,
  });

  final double progress;
  final String? label;
  final List<double> milestoneThresholds;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
              Text(
                '${(clampedProgress * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            return SizedBox(
              height: height,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: clampedProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                    ),
                  ),
                  for (final threshold in milestoneThresholds)
                    Positioned(
                      left: totalWidth * threshold.clamp(0.0, 1.0) - 1,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
