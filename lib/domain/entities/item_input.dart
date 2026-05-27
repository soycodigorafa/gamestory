class CreateItemInput {
  const CreateItemInput({
    required this.projectId,
    required this.name,
    required this.description,
  });

  final String projectId;
  final String name;
  final String description;
}

class UpdateItemInput {
  const UpdateItemInput({
    required this.id,
    this.name,
    this.description,
  });

  final String id;
  final String? name;
  final String? description;
}
