import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/gs_badge.dart';
import '../../../shared/widgets/gs_button.dart';
import '../../../shared/widgets/gs_card.dart';
import '../../../shared/widgets/gs_empty_state.dart';
import '../providers/dialogue_playback_provider.dart';
import '../widgets/playback_choice_card.dart';

class PlaybackScreen extends ConsumerWidget {
  const PlaybackScreen({
    super.key,
    required this.projectId,
    required this.startNodeId,
  });

  final String projectId;
  final String startNodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playback = ref.watch(
      dialoguePlaybackProvider(projectId, startNodeId),
    );
    final notifier = ref.read(
      dialoguePlaybackProvider(projectId, startNodeId).notifier,
    );

    final current = playback.currentNode;
    final choices = notifier.childrenOf(current.id);
    final deadEnd = notifier.isDeadEnd(current.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Exit playback',
        ),
        title: Row(
          children: [
            const Text(
              'Play Mode',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            const GsBadge(
              status: GsBadgeStatus.complete,
              label: 'Simulating',
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GsButton(
              label: 'Restart',
              icon: Icons.replay,
              variant: GsButtonVariant.ghost,
              onPressed: notifier.restart,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: AppColors.surfaceVariant),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _CurrentNodeCard(
                  speakerName: current.speakerName,
                  dialogueText: current.dialogueText,
                ),
                const SizedBox(height: 24),
                if (deadEnd)
                  _DeadEndSection(
                    canGoBack: playback.canGoBack,
                    onBack: notifier.goBack,
                    onRestart: notifier.restart,
                  )
                else ...[
                  _ChoicesHeader(choiceCount: choices.length),
                  const SizedBox(height: 10),
                  for (final choice in choices) ...[
                    PlaybackChoiceCard(
                      node: choice,
                      projectId: projectId,
                      isGated: notifier.isNodeGated(choice),
                      isVisited: playback.visitedNodeIds.contains(choice.id),
                      onTap: () => notifier.chooseNode(choice),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (playback.canGoBack) ...[
                    const SizedBox(height: 8),
                    GsButton(
                      label: 'Back',
                      icon: Icons.arrow_back,
                      variant: GsButtonVariant.secondary,
                      onPressed: notifier.goBack,
                    ),
                  ],
                ],
                if (playback.unlockedItemIds.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _UnlockedItemsPanel(
                    itemIds: playback.unlockedItemIds,
                    projectId: projectId,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentNodeCard extends StatelessWidget {
  const _CurrentNodeCard({
    required this.speakerName,
    required this.dialogueText,
  });

  final String speakerName;
  final String dialogueText;

  @override
  Widget build(BuildContext context) {
    return GsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                speakerName,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            dialogueText,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoicesHeader extends StatelessWidget {
  const _ChoicesHeader({required this.choiceCount});

  final int choiceCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Choose a response',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$choiceCount',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DeadEndSection extends StatelessWidget {
  const _DeadEndSection({
    required this.canGoBack,
    required this.onBack,
    required this.onRestart,
  });

  final bool canGoBack;
  final VoidCallback onBack;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GsEmptyState(
          title: 'End of branch',
          subtitle: 'This dialogue path has reached its conclusion.',
          icon: Icons.flag_outlined,
          ctaLabel: 'Restart',
          onCta: onRestart,
        ),
        if (canGoBack) ...[
          const SizedBox(height: 12),
          GsButton(
            label: 'Back',
            icon: Icons.arrow_back,
            variant: GsButtonVariant.secondary,
            onPressed: onBack,
          ),
        ],
      ],
    );
  }
}

class _UnlockedItemsPanel extends StatelessWidget {
  const _UnlockedItemsPanel({
    required this.itemIds,
    required this.projectId,
  });

  final Set<String> itemIds;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.surfaceVariant),
        const SizedBox(height: 12),
        const Text(
          'ITEMS UNLOCKED THIS SESSION',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            for (final id in itemIds)
              _SessionItemChip(itemId: id, projectId: projectId),
          ],
        ),
      ],
    );
  }
}

class _SessionItemChip extends StatelessWidget {
  const _SessionItemChip({required this.itemId, required this.projectId});

  final String itemId;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline,
              size: 12, color: AppColors.secondary),
          const SizedBox(width: 6),
          Text(
            itemId,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
