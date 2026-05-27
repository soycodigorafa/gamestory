import '../entities/milestone.dart';
import '../entities/milestone_input.dart';

abstract interface class MilestoneRepository {
  Stream<List<Milestone>> watchByProject(String projectId);
  Future<Milestone> create(CreateMilestoneInput input);
  Future<void> update(UpdateMilestoneInput input);
  Future<void> delete(String id);
  Stream<double> watchProgress(String projectId);
}
