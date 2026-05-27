class DialogueNode {
  const DialogueNode({
    required this.id,
    required this.projectId,
    this.parentId,
    required this.speakerName,
    required this.dialogueText,
    required this.sortOrder,
    this.unlockedItemIds = const [],
    this.conditionIds = const [],
  });

  final String id;
  final String projectId;
  final String? parentId;
  final String speakerName;
  final String dialogueText;
  final int sortOrder;
  final List<String> unlockedItemIds;
  final List<String> conditionIds;

  DialogueNode copyWith({
    String? id,
    String? projectId,
    Object? parentId = _sentinel,
    String? speakerName,
    String? dialogueText,
    int? sortOrder,
    List<String>? unlockedItemIds,
    List<String>? conditionIds,
  }) {
    return DialogueNode(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      parentId: parentId == _sentinel ? this.parentId : parentId as String?,
      speakerName: speakerName ?? this.speakerName,
      dialogueText: dialogueText ?? this.dialogueText,
      sortOrder: sortOrder ?? this.sortOrder,
      unlockedItemIds: unlockedItemIds ?? this.unlockedItemIds,
      conditionIds: conditionIds ?? this.conditionIds,
    );
  }
}

const Object _sentinel = Object();
