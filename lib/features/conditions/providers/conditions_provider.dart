import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers/database_provider.dart';
import '../../../domain/entities/condition.dart';
import '../../../domain/entities/condition_input.dart';

part 'conditions_provider.g.dart';

@riverpod
Stream<List<Condition>> conditionList(Ref ref, String projectId) =>
    ref.watch(conditionRepositoryProvider).watchByProject(projectId);

@riverpod
class ConditionsNotifier extends _$ConditionsNotifier {
  @override
  void build(String projectId) {}

  Future<Condition> create(CreateConditionInput input) =>
      ref.read(conditionRepositoryProvider).create(input);

  Future<void> update(UpdateConditionInput input) =>
      ref.read(conditionRepositoryProvider).update(input);

  Future<void> delete(String id) =>
      ref.read(conditionRepositoryProvider).delete(id);
}
