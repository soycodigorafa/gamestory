import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/dialogue_choice.dart';
import '../../canvas/providers/npc_list_provider.dart';
import '../providers/playback_provider.dart';
import '../widgets/flag_debug_panel.dart';

class PlaybackScreen extends ConsumerWidget {
  const PlaybackScreen({super.key, required this.npcId});

  final String npcId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playbackAsync = ref.watch(playbackProvider(npcId));
    final npcName = ref
            .watch(npcListProvider)
            .valueOrNull
            ?.where((n) => n.id == npcId)
            .firstOrNull
            ?.name ??
        'Playback';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to editor',
          onPressed: () => context.goNamed('dialogue-editor',
              pathParameters: {'id': npcId}),
        ),
        title: Text(npcName),
        actions: [
          IconButton(
            icon: const Icon(Icons.replay_rounded),
            tooltip: 'Restart',
            onPressed: playbackAsync.hasValue
                ? () =>
                    ref.read(playbackProvider(npcId).notifier).restart()
                : null,
          ),
        ],
      ),
      body: playbackAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) => _PlaybackBody(npcId: npcId, state: state),
      ),
    );
  }
}

class _PlaybackBody extends ConsumerWidget {
  const _PlaybackBody({required this.npcId, required this.state});

  final String npcId;
  final PlaybackState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceVariant =
        isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final errorColor = isDark ? AppColors.darkError : AppColors.lightError;

    final node = state.currentNode;
    final choices = state.currentChoices;
    final notifier = ref.read(playbackProvider(npcId).notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NodeCard(
                  speakerName: node.speakerName,
                  dialogueText: node.dialogueText,
                  isDark: isDark,
                  surface: surface,
                  surfaceVariant: surfaceVariant,
                  textColor: textColor,
                  mutedColor: mutedColor,
                  primary: primary,
                ),
                const SizedBox(height: 24),
                if (state.isDeadEnd) ...[
                  _DeadEndCard(
                    isDark: isDark,
                    surface: surface,
                    surfaceVariant: surfaceVariant,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    errorColor: errorColor,
                    onRestart: () => notifier.restart(),
                  ),
                ] else ...[
                  Text(
                    'Choose a response',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...choices.map((choice) => _ChoiceRow(
                        choice: choice,
                        isLocked: state.isChoiceLocked(choice.id),
                        isDark: isDark,
                        surface: surface,
                        surfaceVariant: surfaceVariant,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        primary: primary,
                        onTap: () => notifier.chooseOption(choice.id),
                      )),
                ],
              ],
            ),
          ),
        ),
        _BottomBar(
          canGoBack: state.visitedNodes.isNotEmpty,
          isDark: isDark,
          surfaceVariant: surfaceVariant,
          textColor: textColor,
          mutedColor: mutedColor,
          primary: primary,
          onBack: () => notifier.back(),
        ),
        FlagDebugPanel(flagMap: state.flagMap),
      ],
    );
  }
}

class _NodeCard extends StatelessWidget {
  const _NodeCard({
    required this.speakerName,
    required this.dialogueText,
    required this.isDark,
    required this.surface,
    required this.surfaceVariant,
    required this.textColor,
    required this.mutedColor,
    required this.primary,
  });

  final String speakerName;
  final String dialogueText;
  final bool isDark;
  final Color surface;
  final Color surfaceVariant;
  final Color textColor;
  final Color mutedColor;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.person_rounded, size: 14, color: primary),
                const SizedBox(width: 6),
                Text(
                  speakerName.isEmpty ? 'Narrator' : speakerName,
                  style: TextStyle(
                    color: primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              dialogueText.isEmpty ? '(no dialogue text)' : dialogueText,
              style: TextStyle(
                color: dialogueText.isEmpty ? mutedColor : textColor,
                fontSize: 16,
                height: 1.6,
                fontStyle: dialogueText.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.choice,
    required this.isLocked,
    required this.isDark,
    required this.surface,
    required this.surfaceVariant,
    required this.textColor,
    required this.mutedColor,
    required this.primary,
    required this.onTap,
  });

  final DialogueChoice choice;
  final bool isLocked;
  final bool isDark;
  final Color surface;
  final Color surfaceVariant;
  final Color textColor;
  final Color mutedColor;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: isLocked ? 0.45 : 1.0,
        child: Material(
          color: surface,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: isLocked ? null : onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isLocked
                      ? surfaceVariant
                      : primary.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      choice.choiceText.isEmpty
                          ? '(no choice text)'
                          : choice.choiceText,
                      style: TextStyle(
                        color: isLocked ? mutedColor : textColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isLocked)
                    Icon(Icons.lock_rounded, size: 16, color: mutedColor)
                  else
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeadEndCard extends StatelessWidget {
  const _DeadEndCard({
    required this.isDark,
    required this.surface,
    required this.surfaceVariant,
    required this.textColor,
    required this.mutedColor,
    required this.errorColor,
    required this.onRestart,
  });

  final bool isDark;
  final Color surface;
  final Color surfaceVariant;
  final Color textColor;
  final Color mutedColor;
  final Color errorColor;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: surfaceVariant),
      ),
      child: Column(
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 40, color: mutedColor),
          const SizedBox(height: 12),
          Text(
            'Conversation ended',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This node has no outgoing choices.',
            style: TextStyle(color: mutedColor, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRestart,
            icon: const Icon(Icons.replay_rounded, size: 18),
            label: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.canGoBack,
    required this.isDark,
    required this.surfaceVariant,
    required this.textColor,
    required this.mutedColor,
    required this.primary,
    required this.onBack,
  });

  final bool canGoBack;
  final bool isDark;
  final Color surfaceVariant;
  final Color textColor;
  final Color mutedColor;
  final Color primary;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: surfaceVariant)),
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: canGoBack ? onBack : null,
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 18,
              color: canGoBack ? primary : mutedColor,
            ),
            label: Text(
              'Back',
              style: TextStyle(
                color: canGoBack ? primary : mutedColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
