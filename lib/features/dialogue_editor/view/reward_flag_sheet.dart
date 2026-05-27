import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/reward_flag.dart';
import '../providers/dialogue_graph_provider.dart';

class RewardFlagSheet extends ConsumerStatefulWidget {
  const RewardFlagSheet({
    super.key,
    required this.nodeId,
    required this.speakerName,
  });

  final String nodeId;
  final String speakerName;

  static Future<void> show(
    BuildContext context, {
    required String nodeId,
    required String speakerName,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => RewardFlagSheet(
        nodeId: nodeId,
        speakerName: speakerName,
      ),
    );
  }

  @override
  ConsumerState<RewardFlagSheet> createState() => _RewardFlagSheetState();
}

class _RewardFlagSheetState extends ConsumerState<RewardFlagSheet> {
  final _flagNameCtrl = TextEditingController();
  bool _setValue = true;
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
    final secondary = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final errorColor = isDark ? AppColors.darkError : AppColors.lightError;

    final flagsAsync = ref.watch(rewardFlagsByNodeProvider(widget.nodeId));

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
                Icon(Icons.auto_awesome, size: 18, color: secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reward Flags',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (widget.speakerName.isNotEmpty)
                        Text(
                          widget.speakerName,
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
                        'No effects — entering this node sets no flags.',
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
              'Add effect',
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
                  value: _setValue,
                  onChanged: (v) => setState(() => _setValue = v),
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

  Widget _buildFlagRow(RewardFlag flag, Color errorColor, Color mutedColor) {
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
          _ValueBadge(value: flag.setValue),
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
      await ref.read(rewardFlagRepositoryProvider).create(
            CreateRewardFlagInput(
              nodeId: widget.nodeId,
              flagName: name,
              setValue: _setValue,
            ),
          );
      _flagNameCtrl.clear();
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  Future<void> _deleteFlag(String flagId) async {
    await ref.read(rewardFlagRepositoryProvider).delete(flagId);
  }
}

class _ValueToggle extends StatelessWidget {
  const _ValueToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: (value ? secondary : muted).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: (value ? secondary : muted).withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          value ? 'true' : 'false',
          style: TextStyle(
            color: value ? secondary : muted,
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
    final secondary = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final color = value ? secondary : muted;

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
