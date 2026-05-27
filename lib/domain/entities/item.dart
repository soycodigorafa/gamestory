class Item {
  const Item({
    required this.id,
    required this.projectId,
    required this.name,
    required this.description,
  });

  final String id;
  final String projectId;
  final String name;
  final String description;

  Item copyWith({
    String? id,
    String? projectId,
    String? name,
    String? description,
  }) {
    return Item(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
