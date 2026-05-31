import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../database/app_database.dart';

class DriftProjectRepository implements ProjectRepository {
  DriftProjectRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Stream<List<Project>> watchAll() {
    return _db.projectDao.watchAll().map(
          (rows) => rows.map(_rowToEntity).toList(),
        );
  }

  @override
  Future<Project> create(CreateProjectInput input) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    final companion = ProjectsTableCompanion.insert(
      id: id,
      name: input.name,
      filePath: Value(input.filePath),
      createdAt: now,
      updatedAt: now,
    );
    await _db.projectDao.upsert(companion);
    return Project(
      id: id,
      name: input.name,
      description: input.description,
      filePath: input.filePath,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> update(UpdateProjectInput input) async {
    final existing = await _db.projectDao.findById(input.id);
    if (existing == null) return;

    final companion = ProjectsTableCompanion(
      id: Value(input.id),
      name: input.name != null ? Value(input.name!) : const Value.absent(),
      description: input.description != null
          ? Value(input.description!)
          : const Value.absent(),
      filePath: input.filePath != null ? Value(input.filePath) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    await _db.projectDao.updateById(companion);
  }

  @override
  Future<void> delete(String id) => _db.projectDao.deleteById(id);

  Project _rowToEntity(ProjectsTableData row) {
    return Project(
      id: row.id,
      name: row.name,
      description: row.description,
      filePath: row.filePath,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
