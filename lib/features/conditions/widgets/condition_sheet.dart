import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/condition.dart';
import '../../../shared/widgets/gs_bottom_sheet.dart';
import '../../../shared/widgets/gs_button.dart';
import '../../../shared/widgets/gs_text_field.dart';

class ConditionSheet extends StatefulWidget {
  const ConditionSheet({super.key, this.condition});

  final Condition? condition;

  static Future<void> show(BuildContext context, {Condition? condition}) {
    return GsBottomSheet.show(
      context: context,
      title: condition == null ? 'Add Condition' : 'Edit Condition',
      child: ConditionSheet(condition: condition),
    );
  }

  @override
  State<ConditionSheet> createState() => _ConditionSheetState();
}

class _ConditionSheetState extends State<ConditionSheet> {
  late final TextEditingController _expressionController;
  late ConditionType _selectedType;

  @override
  void initState() {
    super.initState();
    _expressionController =
        TextEditingController(text: widget.condition?.expression ?? '');
    _selectedType = widget.condition?.conditionType ?? ConditionType.flag;
  }

  @override
  void dispose() {
    _expressionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.condition != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'CONDITION TYPE',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        _TypeSelector(
          selected: _selectedType,
          onChanged: (t) => setState(() => _selectedType = t),
        ),
        const SizedBox(height: 20),
        GsTextField(
          label: 'Expression',
          hint: _hintForType(_selectedType),
          controller: _expressionController,
          multiline: true,
          autofocus: !isEdit,
        ),
        const SizedBox(height: 8),
        Text(
          _descForType(_selectedType),
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            if (isEdit) ...[
              GsButton(
                label: 'Delete',
                variant: GsButtonVariant.destructive,
                icon: Icons.delete_outline,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: GsButton(
                label: 'Cancel',
                variant: GsButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GsButton(
                label: isEdit ? 'Save Changes' : 'Add Condition',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Changes will be persisted in Milestone 3.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  }

  String _hintForType(ConditionType type) => switch (type) {
        ConditionType.flag => 'e.g. quest_started == true',
        ConditionType.inventory => 'e.g. inventory.contains("sword")',
        ConditionType.stat => 'e.g. player.reputation >= 50',
      };

  String _descForType(ConditionType type) => switch (type) {
        ConditionType.flag => 'Boolean flag that must evaluate to true.',
        ConditionType.inventory =>
          'Player must possess the specified item in their inventory.',
        ConditionType.stat =>
          'A numeric player stat must meet the threshold.',
      };
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({
    required this.selected,
    required this.onChanged,
  });

  final ConditionType selected;
  final ValueChanged<ConditionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final type in ConditionType.values) ...[
          _TypeChip(
            label: type.name.toUpperCase(),
            isSelected: selected == type,
            onTap: () => onChanged(type),
          ),
          if (type != ConditionType.values.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.18)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
