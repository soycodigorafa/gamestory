import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/projects_table.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [ProjectsTable])
class ProjectDao extends DatabaseAccessor<AppDatabase> with _$ProjectDaoMixin {
  ProjectDao(super.db);

  Stream<List<ProjectsTableData>> watchAll() =>
      select(projectsTable).watch();

  Future<ProjectsTableData?> findById(String id) =>
      (select(projectsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(ProjectsTableCompanion companion) =>
      into(projectsTable).insertOnConflictUpdate(companion);

  Future<void> updateById(ProjectsTableCompanion companion) =>
      (update(projectsTable)..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  Future<void> deleteById(String id) =>
      (delete(projectsTable)..where((t) => t.id.equals(id))).go();
}
