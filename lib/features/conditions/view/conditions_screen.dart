import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/condition.dart';
import '../../../shared/utils/stub_data.dart';
import '../../../shared/widgets/gs_badge.dart';
import '../../../shared/widgets/gs_button.dart';
import '../../../shared/widgets/gs_card.dart';
import '../../../shared/widgets/gs_empty_state.dart';
import '../widgets/condition_sheet.dart';

class ConditionsScreen extends StatelessWidget {
  const ConditionsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final conditions = StubData.conditionsForProject(projectId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: conditions.isEmpty
          ? GsEmptyState(
              title: 'No conditions yet',
              subtitle:
                  'Add conditions to gate dialogue nodes behind flags, stats, or inventory checks.',
              icon: Icons.rule_outlined,
              ctaLabel: 'Add Condition',
              onCta: () => ConditionSheet.show(context),
            )
          : _ConditionList(conditions: conditions),
      floatingActionButton: conditions.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              tooltip: 'Add Condition',
              onPressed: () => ConditionSheet.show(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _ConditionList extends StatelessWidget {
  const _ConditionList({required this.conditions});

  final List<Condition> conditions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: conditions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _ConditionRow(
        condition: conditions[i],
        onTap: () => ConditionSheet.show(context, condition: conditions[i]),
      ),
    );
  }
}

class _ConditionRow extends StatelessWidget {
  const _ConditionRow({required this.condition, required this.onTap});

  final Condition condition;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (typeColor, typeLabel) = switch (condition.conditionType) {
      ConditionType.flag => (AppColors.secondary, 'FLAG'),
      ConditionType.inventory => (AppColors.primary, 'INV'),
      ConditionType.stat => (const Color(0xFFFFB547), 'STAT'),
    };

    return GsCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: typeColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              typeLabel,
              style: TextStyle(
                color: typeColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  condition.expression,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                GsBadge(
                  status: GsBadgeStatus.complete,
                  label: 'Active',
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GsButton(
            label: 'Edit',
            variant: GsButtonVariant.ghost,
            icon: Icons.edit_outlined,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
