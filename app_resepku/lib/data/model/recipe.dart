import 'dart:convert';

class Recipe {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Recipe.fromMap(Map<String, dynamic> m) => Recipe(
    id: m['id'],
    title: m['title'] ?? m['name'] ?? '',
    description: m['description'] ?? m['body'] ?? '',
    imageUrl: m['image_url'] ?? m['image'] ?? m['photo'],
    userId: m['user_id'] ?? m['author_id'] ?? 0,
    createdAt: DateTime.parse(m['created_at']),
    updatedAt: DateTime.parse(m['updated_at']),
  );

  factory Recipe.fromJson(String s) => Recipe.fromMap(json.decode(s));

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'image_url': imageUrl,
    'user_id': userId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  String toJson() => json.encode(toMap());
}
