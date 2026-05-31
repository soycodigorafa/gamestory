import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/projects/providers/project_list_provider.dart';
import '../features/projects/providers/project_startup_provider.dart';
import '../features/settings/providers/theme_mode_provider.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class GameStoryApp extends ConsumerStatefulWidget {
  const GameStoryApp({super.key});

  @override
  ConsumerState<GameStoryApp> createState() => _GameStoryAppState();
}

class _GameStoryAppState extends ConsumerState<GameStoryApp> {
  bool _navigatedOnStartup = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final startupAsync = ref.watch(projectStartupProvider);

    return startupAsync.when(
      loading: () => const _SplashScreen(),
      error: (e, _) => _buildApp(themeMode),
      data: (_) {
        if (!_navigatedOnStartup) {
          _navigatedOnStartup = true;
          final project = ref.read(currentProjectProvider);
          if (project != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              appRouter.goNamed('canvas');
            });
          }
        }
        return _buildApp(themeMode);
      },
    );
  }

  Widget _buildApp(ThemeMode themeMode) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'GameStory',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
