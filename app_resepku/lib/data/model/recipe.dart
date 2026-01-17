class Recipe {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image_url'],
    );
  }
}
