import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers/database_provider.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/project_input.dart';

part 'projects_provider.g.dart';

@riverpod
Stream<List<Project>> projectList(Ref ref) =>
    ref.watch(projectRepositoryProvider).watchAll();

@riverpod
class ProjectsNotifier extends _$ProjectsNotifier {
  @override
  void build() {}

  Future<Project> create(CreateProjectInput input) =>
      ref.read(projectRepositoryProvider).create(input);

  Future<void> update(UpdateProjectInput input) =>
      ref.read(projectRepositoryProvider).update(input);

  Future<void> delete(String id) =>
      ref.read(projectRepositoryProvider).delete(id);
}
