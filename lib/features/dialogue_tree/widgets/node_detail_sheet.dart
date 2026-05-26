import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/condition.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../shared/utils/stub_data.dart';
import '../../../shared/widgets/gs_badge.dart';
import '../../../shared/widgets/gs_bottom_sheet.dart';
import '../../../shared/widgets/gs_button.dart';

class NodeDetailSheet extends StatelessWidget {
  const NodeDetailSheet({
    super.key,
    required this.node,
    required this.projectId,
  });

  final DialogueNode node;
  final String projectId;

  static Future<void> show(
    BuildContext context, {
    required DialogueNode node,
    required String projectId,
  }) {
    return GsBottomSheet.show(
      context: context,
      title: 'Node Detail',
      child: NodeDetailSheet(node: node, projectId: projectId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = StubData.itemsForProject(projectId)
        .where((i) => node.unlockedItemIds.contains(i.id))
        .toList();
    final conditions = StubData.conditionsForProject(projectId)
        .where((c) => node.conditionIds.contains(c.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: 'Speaker'),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            node.speakerName,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionLabel(label: 'Dialogue Text'),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Text(
            node.dialogueText,
            style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _SectionLabel(label: 'Item Unlocks'),
            const SizedBox(width: 8),
            GsBadge(
              status: items.isNotEmpty
                  ? GsBadgeStatus.complete
                  : GsBadgeStatus.incomplete,
              label: '${items.length}',
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text(
            'No items unlocked by this node.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          )
        else
          for (final item in items) ...[
            _ItemRow(name: item.name, description: item.description),
            const SizedBox(height: 6),
          ],
        const SizedBox(height: 20),
        Row(
          children: [
            _SectionLabel(label: 'Conditions'),
            const SizedBox(width: 8),
            GsBadge(
              status: conditions.isNotEmpty
                  ? GsBadgeStatus.complete
                  : GsBadgeStatus.incomplete,
              label: '${conditions.length}',
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (conditions.isEmpty)
          const Text(
            'No conditions required for this node.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          )
        else
          for (final cond in conditions) ...[
            _ConditionRow(condition: cond),
            const SizedBox(height: 6),
          ],
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GsButton(
                label: 'Edit Node',
                variant: GsButtonVariant.secondary,
                icon: Icons.edit_outlined,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 8),
            GsButton(
              label: 'Delete',
              variant: GsButtonVariant.destructive,
              icon: Icons.delete_outline,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.name, required this.description});

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 14, color: AppColors.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (description.isNotEmpty)
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionRow extends StatelessWidget {
  const _ConditionRow({required this.condition});

  final Condition condition;

  @override
  Widget build(BuildContext context) {
    final typeLabel = switch (condition.conditionType) {
      ConditionType.flag => 'FLAG',
      ConditionType.inventory => 'INV',
      ConditionType.stat => 'STAT',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              typeLabel,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              condition.expression,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
