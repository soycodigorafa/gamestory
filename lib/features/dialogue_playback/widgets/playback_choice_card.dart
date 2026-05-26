import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../shared/utils/stub_data.dart';
import '../../../shared/widgets/gs_badge.dart';
import '../../../shared/widgets/gs_card.dart';

class PlaybackChoiceCard extends StatelessWidget {
  const PlaybackChoiceCard({
    super.key,
    required this.node,
    required this.projectId,
    required this.isGated,
    required this.isVisited,
    required this.onTap,
  });

  final DialogueNode node;
  final String projectId;
  final bool isGated;
  final bool isVisited;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unlockedItems = StubData.itemsForProject(projectId)
        .where((i) => node.unlockedItemIds.contains(i.id))
        .toList();

    return Opacity(
      opacity: isGated ? 0.5 : 1.0,
      child: GsCard(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    node.speakerName,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    node.dialogueText,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (unlockedItems.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        for (final item in unlockedItems)
                          _ItemChip(name: item.name),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isGated)
                  const GsBadge(status: GsBadgeStatus.locked)
                else if (isVisited)
                  const GsBadge(
                    status: GsBadgeStatus.complete,
                    label: 'Visited',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemChip extends StatelessWidget {
  const _ItemChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 11, color: AppColors.secondary),
          const SizedBox(width: 4),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
