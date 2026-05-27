class Milestone {
  const Milestone({
    required this.id,
    required this.projectId,
    required this.label,
    required this.targetCount,
    this.completedAt,
  });

  final String id;
  final String projectId;
  final String label;
  final int targetCount;
  final DateTime? completedAt;

  bool get isCompleted => completedAt != null;

  Milestone copyWith({
    String? id,
    String? projectId,
    String? label,
    int? targetCount,
    Object? completedAt = _milestoneSentinel,
  }) {
    return Milestone(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      label: label ?? this.label,
      targetCount: targetCount ?? this.targetCount,
      completedAt: completedAt == _milestoneSentinel
          ? this.completedAt
          : completedAt as DateTime?,
    );
  }
}

const Object _milestoneSentinel = Object();
