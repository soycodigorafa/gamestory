class Milestone {
  const Milestone({
    required this.id,
    required this.projectId,
    required this.label,
    required this.thresholdPercent,
    this.completedAt,
  });

  final String id;
  final String projectId;
  final String label;
  final int thresholdPercent;
  final DateTime? completedAt;

  bool get isCompleted => completedAt != null;
}
