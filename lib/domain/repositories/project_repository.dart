import '../entities/project.dart';
import '../entities/project_input.dart';

abstract interface class ProjectRepository {
  Stream<List<Project>> watchAll();
  Future<Project> create(CreateProjectInput input);
  Future<void> update(UpdateProjectInput input);
  Future<void> delete(String id);
}
