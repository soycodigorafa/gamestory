class CreateNodeInput {
  const CreateNodeInput({
    required this.projectId,
    this.parentId,
    required this.speakerName,
    required this.dialogueText,
    required this.sortOrder,
  });

  final String projectId;
  final String? parentId;
  final String speakerName;
  final String dialogueText;
  final int sortOrder;
}

class UpdateNodeInput {
  const UpdateNodeInput({
    required this.id,
    this.speakerName,
    this.dialogueText,
    this.sortOrder,
  });

  final String id;
  final String? speakerName;
  final String? dialogueText;
  final int? sortOrder;
}
