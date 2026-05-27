import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/settings/providers/theme_mode_provider.dart';

class CanvasScreen extends ConsumerWidget {
  const CanvasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GameStory'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round),
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: () =>
                ref.read(themeModeNotifierProvider.notifier).toggle(),
          ),
        ],
      ),
      body: const Center(
        child: Text('NPC Canvas — coming in M2'),
      ),
    );
  }
}
