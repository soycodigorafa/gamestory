import 'condition.dart';

class CreateConditionInput {
  const CreateConditionInput({
    required this.projectId,
    required this.expression,
    required this.conditionType,
  });

  final String projectId;
  final String expression;
  final ConditionType conditionType;
}

class UpdateConditionInput {
  const UpdateConditionInput({
    required this.id,
    this.expression,
    this.conditionType,
  });

  final String id;
  final String? expression;
  final ConditionType? conditionType;
}
