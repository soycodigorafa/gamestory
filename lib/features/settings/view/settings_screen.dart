import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../providers/theme_mode_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _SectionLabel(label: 'Appearance', mutedColor: mutedColor),
          const SizedBox(height: 8),
          _Card(
            surface: surface,
            surfaceVariant: surfaceVariant,
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
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                isDark
                    ? 'Currently using dark theme'
                    : 'Currently using light theme',
                style: TextStyle(color: mutedColor, fontSize: 12),
              ),
              activeThumbColor: primary,
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: 'Info', mutedColor: mutedColor),
          const SizedBox(height: 8),
          _Card(
            surface: surface,
            surfaceVariant: surfaceVariant,
            child: ListTile(
              leading: Icon(Icons.info_outline_rounded, color: primary),
              title: Text(
                'About GameStory',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Version, license & platform info',
                style: TextStyle(color: mutedColor, fontSize: 12),
              ),
              trailing:
                  Icon(Icons.chevron_right_rounded, color: mutedColor),
              onTap: () => context.pushNamed('about'),
            ),
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

class _Card extends StatelessWidget {
  const _Card({
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
