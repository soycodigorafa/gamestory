import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/project.dart';
import '../../domain/entities/project_input.dart';
import '../../domain/repositories/project_repository.dart';
import '../database/app_database.dart';
import '../database/daos/project_dao.dart';
import '../database/tables/projects_table.dart';

class DriftProjectRepository implements ProjectRepository {
  DriftProjectRepository(AppDatabase db) : _dao = ProjectDao(db);

  final ProjectDao _dao;
  final _uuid = const Uuid();

  @override
  Stream<List<Project>> watchAll() =>
      _dao.watchAll().map((rows) => rows.map(_toEntity).toList());

  @override
  Future<Project> create(CreateProjectInput input) async {
    final now = DateTime.now();
    final row = ProjectsCompanion.insert(
      id: _uuid.v4(),
      name: input.name,
      description: Value(input.description),
      createdAt: now,
      updatedAt: now,
    );
    await _dao.insertProject(row);
    return _toEntity(ProjectRow(
      id: row.id.value,
      name: row.name.value,
      description: row.description.value,
      createdAt: now,
      updatedAt: now,
    ));
  }

  @override
  Future<void> update(UpdateProjectInput input) async {
    await _dao.updateProject(
      ProjectsCompanion(
        id: Value(input.id),
        name: input.name != null ? Value(input.name!) : const Value.absent(),
        description: input.description != null
            ? Value(input.description!)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(String id) => _dao.deleteProject(id);

  Project _toEntity(ProjectRow row) => Project(
        id: row.id,
        name: row.name,
        description: row.description,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
}
