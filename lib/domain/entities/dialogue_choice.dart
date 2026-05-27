class DialogueChoice {
  const DialogueChoice({
    required this.id,
    required this.fromNodeId,
    this.toNodeId,
    required this.choiceText,
    required this.sortOrder,
  });

  final String id;
  final String fromNodeId;
  final String? toNodeId;
  final String choiceText;
  final int sortOrder;

  DialogueChoice copyWith({
    String? id,
    String? fromNodeId,
    Object? toNodeId = _sentinel,
    String? choiceText,
    int? sortOrder,
  }) {
    return DialogueChoice(
      id: id ?? this.id,
      fromNodeId: fromNodeId ?? this.fromNodeId,
      toNodeId: toNodeId == _sentinel ? this.toNodeId : toNodeId as String?,
      choiceText: choiceText ?? this.choiceText,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

const Object _sentinel = Object();

class CreateChoiceInput {
  const CreateChoiceInput({
    required this.fromNodeId,
    this.toNodeId,
    this.choiceText = '',
    this.sortOrder = 0,
  });

  final String fromNodeId;
  final String? toNodeId;
  final String choiceText;
  final int sortOrder;
}

class UpdateChoiceInput {
  const UpdateChoiceInput({
    required this.id,
    this.toNodeId,
    this.clearToNodeId = false,
    this.choiceText,
    this.sortOrder,
  });

  final String id;
  final String? toNodeId;
  final bool clearToNodeId;
  final String? choiceText;
  final int? sortOrder;
}
