import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/drift_project_repository.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../canvas/providers/npc_list_provider.dart';

part 'project_list_provider.g.dart';

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

  Future<void> createProject(String name, {String description = ''}) {
    return ref.read(projectRepositoryProvider).create(
          CreateProjectInput(name: name, description: description),
        );
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

  void set(Project project) => state = project;

  void clear() => state = null;
}
