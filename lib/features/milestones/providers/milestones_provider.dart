import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers/database_provider.dart';
import '../../../domain/entities/milestone.dart';
import '../../../domain/entities/milestone_input.dart';

part 'milestones_provider.g.dart';

@riverpod
Stream<List<Milestone>> milestoneList(Ref ref, String projectId) =>
    ref.watch(milestoneRepositoryProvider).watchByProject(projectId);

@riverpod
Stream<double> projectProgress(Ref ref, String projectId) =>
    ref.watch(milestoneRepositoryProvider).watchProgress(projectId);

@riverpod
class MilestonesNotifier extends _$MilestonesNotifier {
  @override
  void build(String projectId) {}

  Future<Milestone> create(CreateMilestoneInput input) =>
      ref.read(milestoneRepositoryProvider).create(input);

  Future<void> update(UpdateMilestoneInput input) =>
      ref.read(milestoneRepositoryProvider).update(input);

  Future<void> delete(String id) =>
      ref.read(milestoneRepositoryProvider).delete(id);
}
