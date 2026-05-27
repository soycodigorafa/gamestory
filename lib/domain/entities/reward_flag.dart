class RewardFlag {
  const RewardFlag({
    required this.id,
    required this.nodeId,
    required this.flagName,
    required this.setValue,
  });

  final String id;
  final String nodeId;
  final String flagName;
  final bool setValue;

  RewardFlag copyWith({
    String? id,
    String? nodeId,
    String? flagName,
    bool? setValue,
  }) {
    return RewardFlag(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      flagName: flagName ?? this.flagName,
      setValue: setValue ?? this.setValue,
    );
  }
}

class CreateRewardFlagInput {
  const CreateRewardFlagInput({
    required this.nodeId,
    required this.flagName,
    this.setValue = true,
  });

  final String nodeId;
  final String flagName;
  final bool setValue;
}
