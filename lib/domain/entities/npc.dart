class Npc {
  const Npc({
    required this.id,
    required this.projectId,
    required this.name,
    required this.description,
    required this.canvasX,
    required this.canvasY,
    required this.colorHex,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String projectId;
  final String name;
  final String description;
  final double canvasX;
  final double canvasY;
  final String colorHex;
  final DateTime createdAt;
  final DateTime updatedAt;

  Npc copyWith({
    String? id,
    String? projectId,
    String? name,
    String? description,
    double? canvasX,
    double? canvasY,
    String? colorHex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Npc(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      canvasX: canvasX ?? this.canvasX,
      canvasY: canvasY ?? this.canvasY,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateNpcInput {
  const CreateNpcInput({
    required this.name,
    required this.projectId,
    this.description = '',
    this.canvasX = 0,
    this.canvasY = 0,
    this.colorHex = '#7B61FF',
  });

  final String name;
  final String projectId;
  final String description;
  final double canvasX;
  final double canvasY;
  final String colorHex;
}

class UpdateNpcInput {
  const UpdateNpcInput({
    required this.id,
    this.name,
    this.description,
    this.canvasX,
    this.canvasY,
    this.colorHex,
  });

  final String id;
  final String? name;
  final String? description;
  final double? canvasX;
  final double? canvasY;
  final String? colorHex;
}
