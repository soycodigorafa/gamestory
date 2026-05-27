class RequirementFlag {
  const RequirementFlag({
    required this.id,
    required this.choiceId,
    required this.flagName,
    required this.requiredValue,
  });

  final String id;
  final String choiceId;
  final String flagName;
  final bool requiredValue;

  RequirementFlag copyWith({
    String? id,
    String? choiceId,
    String? flagName,
    bool? requiredValue,
  }) {
    return RequirementFlag(
      id: id ?? this.id,
      choiceId: choiceId ?? this.choiceId,
      flagName: flagName ?? this.flagName,
      requiredValue: requiredValue ?? this.requiredValue,
    );
  }
}

class CreateRequirementFlagInput {
  const CreateRequirementFlagInput({
    required this.choiceId,
    required this.flagName,
    this.requiredValue = true,
  });

  final String choiceId;
  final String flagName;
  final bool requiredValue;
}
