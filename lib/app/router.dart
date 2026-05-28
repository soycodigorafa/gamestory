import 'package:go_router/go_router.dart';

import '../features/canvas/view/canvas_screen.dart';
import '../features/dialogue_editor/view/dialogue_editor_screen.dart';
import '../features/playback/view/playback_screen.dart';
import '../features/settings/view/about_screen.dart';
import '../features/settings/view/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'canvas',
      builder: (context, state) => const CanvasScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/npc/:id',
      name: 'dialogue-editor',
      builder: (context, state) => DialogueEditorScreen(
        npcId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/npc/:id/play',
      name: 'playback',
      builder: (context, state) => PlaybackScreen(
        npcId: state.pathParameters['id']!,
      ),
    ),
  ],
);
