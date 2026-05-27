import '../entities/requirement_flag.dart';

abstract interface class RequirementFlagRepository {
  Stream<List<RequirementFlag>> watchByChoice(String choiceId);
  Future<List<RequirementFlag>> getByChoiceIds(List<String> ids);
  Future<RequirementFlag> create(CreateRequirementFlagInput input);
  Future<void> delete(String id);
  Future<void> deleteByChoiceId(String choiceId);
}
