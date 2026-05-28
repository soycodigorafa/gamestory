import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../providers/theme_mode_provider.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceVariant =
        isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _AppHeader(
            primary: primary,
            surface: surface,
            surfaceVariant: surfaceVariant,
            textColor: textColor,
            mutedColor: mutedColor,
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: 'Appearance', mutedColor: mutedColor),
          const SizedBox(height: 8),
          _SettingsCard(
            surfaceVariant: surfaceVariant,
            surface: surface,
            child: SwitchListTile(
              value: isDark,
              onChanged: (_) =>
                  ref.read(themeModeNotifierProvider.notifier).toggle(),
              secondary: Icon(
                isDark ? Icons.nightlight_round : Icons.wb_sunny_outlined,
                color: primary,
              ),
              title: Text(
                'Dark mode',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                isDark ? 'Currently using dark theme' : 'Currently using light theme',
                style: TextStyle(color: mutedColor, fontSize: 12),
              ),
              activeThumbColor: primary,
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: 'Platform support', mutedColor: mutedColor),
          const SizedBox(height: 8),
          _SettingsCard(
            surfaceVariant: surfaceVariant,
            surface: surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PlatformChip(label: 'iOS', color: primary),
                  _PlatformChip(label: 'Android', color: primary),
                  _PlatformChip(label: 'macOS', color: primary),
                  _PlatformChip(label: 'Windows', color: primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: 'License', mutedColor: mutedColor),
          const SizedBox(height: 8),
          _SettingsCard(
            surfaceVariant: surfaceVariant,
            surface: surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MIT License',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Copyright © 2025 GameStory contributors. '
                    'Permission is hereby granted, free of charge, to any person obtaining a copy of this software.',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Built with Flutter · offline-first',
              style: TextStyle(color: mutedColor, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader({
    required this.primary,
    required this.surface,
    required this.surfaceVariant,
    required this.textColor,
    required this.mutedColor,
  });

  final Color primary;
  final Color surface;
  final Color surfaceVariant;
  final Color textColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: surfaceVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.auto_stories_rounded, color: primary, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GameStory',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'v1.0.0 · NPC dialogue flow editor',
                style: TextStyle(color: mutedColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.mutedColor});

  final String label;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: mutedColor,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.surface,
    required this.surfaceVariant,
    required this.child,
  });

  final Color surface;
  final Color surfaceVariant;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: surfaceVariant),
      ),
      child: child,
    );
  }
}

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
