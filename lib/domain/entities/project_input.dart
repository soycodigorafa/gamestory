class CreateProjectInput {
  const CreateProjectInput({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

class UpdateProjectInput {
  const UpdateProjectInput({
    required this.id,
    this.name,
    this.description,
  });

  final String id;
  final String? name;
  final String? description;
}
