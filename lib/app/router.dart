import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/catalogue/view/catalogue_screen.dart';
import '../features/projects/view/project_detail_screen.dart';
import '../features/projects/view/projects_screen.dart';
import '../shared/widgets/app_shell.dart';

abstract final class AppRoutes {
  static const projects = '/';
  static const projectDetail = '/projects/:id';
  static const catalogue = '/catalogue';

  static String projectDetailPath(String id) => '/projects/$id';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.projects,
  debugLogDiagnostics: kDebugMode,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.projects,
          name: 'projects',
          builder: (context, state) => const ProjectsScreen(),
        ),
        GoRoute(
          path: AppRoutes.projectDetail,
          name: 'projectDetail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProjectDetailScreen(projectId: id);
          },
        ),
        if (kDebugMode)
          GoRoute(
            path: AppRoutes.catalogue,
            name: 'catalogue',
            builder: (context, state) => const CatalogueScreen(),
          ),
      ],
    ),
  ],
);
