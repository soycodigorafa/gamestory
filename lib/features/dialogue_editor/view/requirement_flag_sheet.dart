import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/requirement_flag.dart';
import '../../export/providers/project_dirty_provider.dart';
import '../providers/dialogue_graph_provider.dart';

class RequirementFlagSheet extends ConsumerStatefulWidget {
  const RequirementFlagSheet({
    super.key,
    required this.choiceId,
    required this.choiceText,
  });

  final String choiceId;
  final String choiceText;

  static Future<void> show(
    BuildContext context, {
    required String choiceId,
    required String choiceText,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => RequirementFlagSheet(
        choiceId: choiceId,
        choiceText: choiceText,
      ),
    );
  }

  @override
  ConsumerState<RequirementFlagSheet> createState() =>
      _RequirementFlagSheetState();
}

class _RequirementFlagSheetState extends ConsumerState<RequirementFlagSheet> {
  final _flagNameCtrl = TextEditingController();
  bool _requiredValue = true;
  bool _adding = false;

  @override
  void dispose() {
    _flagNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final errorColor = isDark ? AppColors.darkError : AppColors.lightError;

    final flagsAsync =
        ref.watch(requirementFlagsByChoiceProvider(widget.choiceId));

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: mutedColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.lock_outline, size: 18, color: primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Requirement Flags',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (widget.choiceText.isNotEmpty)
                        Text(
                          widget.choiceText,
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            flagsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Text('Error: $e'),
              data: (flags) => flags.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No requirements — this choice is always available.',
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : Column(
                      children: flags
                          .map((f) => _buildFlagRow(f, errorColor, mutedColor))
                          .toList(),
                    ),
            ),
            const Divider(height: 24),
            Text(
              'Add requirement',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _flagNameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'flag_name',
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 13),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addFlag(),
                  ),
                ),
                const SizedBox(width: 8),
                _ValueToggle(
                  value: _requiredValue,
                  onChanged: (v) => setState(() => _requiredValue = v),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _adding ? null : _addFlag,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    minimumSize: const Size(0, 36),
                  ),
                  child: _adding
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagRow(
      RequirementFlag flag, Color errorColor, Color mutedColor) {
    return Padding(
      key: ValueKey(flag.id),
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.flag_rounded, size: 14, color: mutedColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              flag.flagName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 6),
          _ValueBadge(value: flag.requiredValue),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.close, size: 16, color: errorColor),
            onPressed: () => _deleteFlag(flag.id),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }

  Future<void> _addFlag() async {
    final name = _flagNameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _adding = true);
    try {
      await ref.read(requirementFlagRepositoryProvider).create(
            CreateRequirementFlagInput(
              choiceId: widget.choiceId,
              flagName: name,
              requiredValue: _requiredValue,
            ),
          );
      _flagNameCtrl.clear();
      ref.read(projectDirtyProvider.notifier).markDirty();
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  Future<void> _deleteFlag(String flagId) async {
    await ref.read(requirementFlagRepositoryProvider).delete(flagId);
    ref.read(projectDirtyProvider.notifier).markDirty();
  }
}

class _ValueToggle extends StatelessWidget {
  const _ValueToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: (value ? primary : muted).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: (value ? primary : muted).withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          value ? 'true' : 'false',
          style: TextStyle(
            color: value ? primary : muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ValueBadge extends StatelessWidget {
  const _ValueBadge({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final color = value ? primary : muted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        value ? 'true' : 'false',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
