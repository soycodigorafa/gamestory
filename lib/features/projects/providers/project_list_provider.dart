import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repositories/drift_project_repository.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../canvas/providers/npc_list_provider.dart';
import '../../export/services/gsp_export_service.dart';

part 'project_list_provider.g.dart';

const _kLastProjectIdKey = 'last_project_id';

@Riverpod(keepAlive: true)
ProjectRepository projectRepository(ProjectRepositoryRef ref) {
  return DriftProjectRepository(ref.watch(appDatabaseProvider));
}

@riverpod
class ProjectList extends _$ProjectList {
  @override
  Stream<List<Project>> build() {
    return ref.watch(projectRepositoryProvider).watchAll();
  }

  Future<Project?> createProject(String name, {String description = ''}) async {
    final project = await ref.read(projectRepositoryProvider).create(
      CreateProjectInput(name: name, description: description),
    );

    String? filePath;
    final isMobile = Platform.isAndroid || Platform.isIOS;

    if (isMobile) {
      final docsDir = await getApplicationDocumentsDirectory();
      final projectsDir = Directory('${docsDir.path}/projects');
      await projectsDir.create(recursive: true);
      filePath = '${projectsDir.path}/${project.id}.gsp';
    } else {
      final sanitized = name
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .trim()
          .replaceAll(' ', '_');
      filePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save project',
        fileName: '$sanitized.gsp',
        type: FileType.custom,
        allowedExtensions: ['gsp'],
      );
      if (filePath == null) {
        await ref.read(projectRepositoryProvider).delete(project.id);
        return null;
      }
    }

    const service = GspExportService();
    await service.saveToPath(filePath, project, []);

    await ref.read(projectRepositoryProvider).update(
      UpdateProjectInput(id: project.id, filePath: filePath),
    );

    return project.copyWith(filePath: filePath);
  }

  Future<void> renameProject(String id, String name) {
    return ref.read(projectRepositoryProvider).update(
          UpdateProjectInput(id: id, name: name),
        );
  }

  Future<void> deleteProject(String id) {
    return ref.read(projectRepositoryProvider).delete(id);
  }
}

@Riverpod(keepAlive: true)
class CurrentProject extends _$CurrentProject {
  @override
  Project? build() => null;

  void set(Project project) {
    state = project;
    SharedPreferences.getInstance()
        .then((p) => p.setString(_kLastProjectIdKey, project.id));
  }

  void clear() {
    state = null;
    SharedPreferences.getInstance().then((p) => p.remove(_kLastProjectIdKey));
  }
}
