enum ConditionType { flag, inventory, stat }

class Condition {
  const Condition({
    required this.id,
    required this.projectId,
    required this.expression,
    required this.conditionType,
  });

  final String id;
  final String projectId;
  final String expression;
  final ConditionType conditionType;
}
