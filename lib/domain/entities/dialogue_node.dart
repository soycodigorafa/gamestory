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
}
