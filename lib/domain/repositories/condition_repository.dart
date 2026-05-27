import '../entities/condition.dart';
import '../entities/condition_input.dart';

abstract interface class ConditionRepository {
  Stream<List<Condition>> watchByProject(String projectId);
  Future<Condition> create(CreateConditionInput input);
  Future<void> update(UpdateConditionInput input);
  Future<void> delete(String id);
}
