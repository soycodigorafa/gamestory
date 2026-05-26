import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../features/catalogue/view/catalogue_screen.dart';
import 'theme/app_theme.dart';

class GameStoryApp extends StatelessWidget {
  const GameStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameStory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: kDebugMode ? const CatalogueScreen() : const Placeholder(),
    );
  }
}
