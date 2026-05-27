class DialogueNode {
  const DialogueNode({
    required this.id,
    required this.npcId,
    required this.speakerName,
    required this.dialogueText,
    required this.isStart,
    required this.layoutX,
    required this.layoutY,
  });

  final String id;
  final String npcId;
  final String speakerName;
  final String dialogueText;
  final bool isStart;
  final double layoutX;
  final double layoutY;

  DialogueNode copyWith({
    String? id,
    String? npcId,
    String? speakerName,
    String? dialogueText,
    bool? isStart,
    double? layoutX,
    double? layoutY,
  }) {
    return DialogueNode(
      id: id ?? this.id,
      npcId: npcId ?? this.npcId,
      speakerName: speakerName ?? this.speakerName,
      dialogueText: dialogueText ?? this.dialogueText,
      isStart: isStart ?? this.isStart,
      layoutX: layoutX ?? this.layoutX,
      layoutY: layoutY ?? this.layoutY,
    );
  }
}

class CreateNodeInput {
  const CreateNodeInput({
    required this.npcId,
    this.speakerName = '',
    this.dialogueText = '',
    this.isStart = false,
    this.layoutX = 0,
    this.layoutY = 0,
  });

  final String npcId;
  final String speakerName;
  final String dialogueText;
  final bool isStart;
  final double layoutX;
  final double layoutY;
}

class UpdateNodeInput {
  const UpdateNodeInput({
    required this.id,
    this.speakerName,
    this.dialogueText,
    this.isStart,
    this.layoutX,
    this.layoutY,
  });

  final String id;
  final String? speakerName;
  final String? dialogueText;
  final bool? isStart;
  final double? layoutX;
  final double? layoutY;
}
