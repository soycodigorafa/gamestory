class CreateMilestoneInput {
  const CreateMilestoneInput({
    required this.projectId,
    required this.label,
    required this.targetCount,
  });

  final String projectId;
  final String label;
  final int targetCount;
}

class UpdateMilestoneInput {
  const UpdateMilestoneInput({
    required this.id,
    this.label,
    this.targetCount,
    this.completedAt,
    this.clearCompletedAt = false,
  });

  final String id;
  final String? label;
  final int? targetCount;
  final DateTime? completedAt;
  final bool clearCompletedAt;
}
