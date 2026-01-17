import 'dart:convert';

class Recipe {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    // Parse ingredients - bisa jadi String atau sudah List
    List<String> ingredientsList = [];
    if (map['ingredients'] != null) {
      if (map['ingredients'] is String) {
        // Jika String, parse sebagai JSON array
        ingredientsList = List<String>.from(jsonDecode(map['ingredients']) ?? []);
      } else if (map['ingredients'] is List) {
        // Jika sudah List
        ingredientsList = List<String>.from(map['ingredients']);
      }
    }

    // Parse steps - bisa jadi String atau sudah List
    List<String> stepsList = [];
    if (map['steps'] != null) {
      if (map['steps'] is String) {
        // Jika String, parse sebagai JSON array
        stepsList = List<String>.from(jsonDecode(map['steps']) ?? []);
      } else if (map['steps'] is List) {
        // Jika sudah List
        stepsList = List<String>.from(map['steps']);
      }
    }

    return Recipe(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image_url'],
      ingredients: ingredientsList,
      steps: stepsList,
    );
  }
}
