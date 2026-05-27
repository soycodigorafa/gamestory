import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/projects_table.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [Projects])
class ProjectDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectDaoMixin {
  ProjectDao(super.db);

  Stream<List<ProjectRow>> watchAll() => select(projects).watch();

  Future<void> insertProject(ProjectsCompanion companion) =>
      into(projects).insert(companion);

  Future<bool> updateProject(ProjectsCompanion companion) =>
      update(projects).replace(companion);

  Future<int> deleteProject(String id) =>
      (delete(projects)..where((t) => t.id.equals(id))).go();
}
