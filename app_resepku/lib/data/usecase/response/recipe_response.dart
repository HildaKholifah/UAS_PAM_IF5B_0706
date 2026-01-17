import 'package:app_resepku/data/model/recipe.dart';

class RecipeResponse {
  final String status;
  final String message;
  final List<Recipe> data;

  RecipeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RecipeResponse.fromMap(Map<String, dynamic> json) {
    try {
      return RecipeResponse(
        status: json['status'] ?? 'unknown',
        message: json['message'] ?? '',
        data: List<Recipe>.from((json['data'] ?? []).map((e) => Recipe.fromMap(e as Map<String, dynamic>))),
      );
    } catch (e) {
      print('❌ Error parsing RecipeResponse: $e');
      rethrow;
    }
  }
}
