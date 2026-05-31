import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'project_list_provider.dart';

part 'project_startup_provider.g.dart';

const _kLastProjectIdKey = 'last_project_id';

class StartupResult {
  const StartupResult({this.removedProjectNames = const []});

  final List<String> removedProjectNames;
}

@Riverpod(keepAlive: true)
Future<StartupResult> projectStartup(Ref ref) async {
  final projectRepo = ref.read(projectRepositoryProvider);

  final allProjects = await projectRepo.watchAll().first;

  final removedNames = <String>[];

  for (final project in allProjects) {
    if (project.filePath != null) {
      final exists = File(project.filePath!).existsSync();
      if (!exists) {
        removedNames.add(project.name);
        await projectRepo.delete(project.id);
      }
    }
  }

  final prefs = await SharedPreferences.getInstance();
  final lastId = prefs.getString(_kLastProjectIdKey);

  if (lastId != null) {
    final remaining = await projectRepo.watchAll().first;
    final match = remaining.where((p) => p.id == lastId).firstOrNull;

    if (match != null && match.filePath != null) {
      ref.read(currentProjectProvider.notifier).set(match);
    } else {
      await prefs.remove(_kLastProjectIdKey);
    }
  }

  return StartupResult(removedProjectNames: removedNames);
}
