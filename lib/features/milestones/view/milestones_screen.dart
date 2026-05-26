import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/milestone.dart';
import '../../../shared/utils/stub_data.dart';
import '../../../shared/widgets/gs_badge.dart';
import '../../../shared/widgets/gs_progress_bar.dart';

class MilestonesScreen extends StatelessWidget {
  const MilestonesScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final milestones = StubData.milestonesForProject(projectId);
    final progress = StubData.progressForProject(projectId);
    final allComplete = milestones.every((m) => m.isCompleted);

    final thresholds =
        milestones.map((m) => m.thresholdPercent / 100.0).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NARRATIVE PROGRESS',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GsProgressBar(
                    progress: progress,
                    label: 'Unlock logic defined',
                    milestoneThresholds: thresholds,
                    height: 10,
                  ),
                  const SizedBox(height: 20),
                  if (allComplete) _NarrativeCompleteBanner(),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'ACHIEVEMENTS',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          SliverList.separated(
            itemCount: milestones.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MilestoneCard(
                milestone: milestones[i],
                currentProgress: progress,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

class _NarrativeCompleteBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.secondary.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Narrative Complete!',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'All unlock logic has been fully defined.',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          GsBadge(
            status: GsBadgeStatus.complete,
            label: '100%',
          ),
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.milestone,
    required this.currentProgress,
  });

  final Milestone milestone;
  final double currentProgress;

  @override
  Widget build(BuildContext context) {
    final isCompleted = milestone.isCompleted;
    final thresholdProgress = milestone.thresholdPercent / 100.0;
    final isReachable = currentProgress >= thresholdProgress;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.secondary.withValues(alpha: 0.07)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppColors.secondary.withValues(alpha: 0.35)
              : AppColors.surfaceVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.secondary.withValues(alpha: 0.15)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle_outline : Icons.flag_outlined,
              color: isCompleted ? AppColors.secondary : AppColors.muted,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.label,
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.onSurface
                        : AppColors.onSurface.withValues(alpha: 0.75),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isCompleted && milestone.completedAt != null
                      ? 'Completed ${_formatDate(milestone.completedAt!)}'
                      : '${milestone.thresholdPercent}% of nodes required',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GsBadge(
            status: isCompleted
                ? GsBadgeStatus.complete
                : isReachable
                    ? GsBadgeStatus.incomplete
                    : GsBadgeStatus.locked,
            label: isCompleted
                ? 'Done'
                : '${milestone.thresholdPercent}%',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
