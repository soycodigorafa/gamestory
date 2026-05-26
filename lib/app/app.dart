import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class GameStoryApp extends StatelessWidget {
  const GameStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GameStory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
