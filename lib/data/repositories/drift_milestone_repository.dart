import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/milestone.dart';
import '../../domain/entities/milestone_input.dart';
import '../../domain/repositories/milestone_repository.dart';
import '../database/app_database.dart';
import '../database/daos/milestone_dao.dart';
import '../database/tables/milestones_table.dart';

class DriftMilestoneRepository implements MilestoneRepository {
  DriftMilestoneRepository(AppDatabase db) : _dao = MilestoneDao(db);

  final MilestoneDao _dao;
  final _uuid = const Uuid();

  @override
  Stream<List<Milestone>> watchByProject(String projectId) =>
      _dao.watchByProject(projectId).map(
            (rows) => rows.map(_toEntity).toList(),
          );

  @override
  Future<Milestone> create(CreateMilestoneInput input) async {
    final id = _uuid.v4();
    await _dao.insertMilestone(
      MilestonesCompanion.insert(
        id: id,
        projectId: input.projectId,
        label: input.label,
        targetCount: input.targetCount,
      ),
    );
    return Milestone(
      id: id,
      projectId: input.projectId,
      label: input.label,
      targetCount: input.targetCount,
    );
  }

  @override
  Future<void> update(UpdateMilestoneInput input) async {
    await _dao.updateMilestone(
      MilestonesCompanion(
        id: Value(input.id),
        label: input.label != null ? Value(input.label!) : const Value.absent(),
        targetCount: input.targetCount != null
            ? Value(input.targetCount!)
            : const Value.absent(),
        completedAt: input.clearCompletedAt
            ? const Value(null)
            : input.completedAt != null
                ? Value(input.completedAt)
                : const Value.absent(),
      ),
    );
  }

  @override
  Future<void> delete(String id) => _dao.deleteMilestone(id);

  @override
  Stream<double> watchProgress(String projectId) =>
      _dao.watchProgress(projectId);

  Milestone _toEntity(MilestoneRow row) => Milestone(
        id: row.id,
        projectId: row.projectId,
        label: row.label,
        targetCount: row.targetCount,
        completedAt: row.completedAt,
      );
}
