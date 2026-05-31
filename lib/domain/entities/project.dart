class Project {
  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.filePath,
  });

  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? filePath;

  Project copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? filePath,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      filePath: filePath ?? this.filePath,
    );
  }
}

class CreateProjectInput {
  const CreateProjectInput({
    required this.name,
    this.description = '',
    this.filePath,
  });

  final String name;
  final String description;
  final String? filePath;
}

class UpdateProjectInput {
  const UpdateProjectInput({
    required this.id,
    this.name,
    this.description,
    this.filePath,
  });

  final String id;
  final String? name;
  final String? description;
  final String? filePath;
}
