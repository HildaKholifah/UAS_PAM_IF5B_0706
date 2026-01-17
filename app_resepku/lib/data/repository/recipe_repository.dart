import 'dart:convert';
import 'package:app_resepku/data/model/recipe.dart';
import 'package:app_resepku/data/service/http_service.dart';

class RecipeRepository {
  final HttpService httpService = HttpService();

  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await httpService.get('recipes');

      if (response.statusCode == 200) {
        final jsonBody = response.body;

        // Parse JSON string terlebih dahulu
        final decoded = jsonDecode(jsonBody);

        // Jika response adalah array langsung
        if (decoded is List) {
          final list = (decoded as List)
              .map((e) => Recipe.fromMap(e as Map<String, dynamic>))
              .toList();
          return list;
        } else if (decoded is Map<String, dynamic>) {
          // Jika response adalah object dengan key 'data'
          if (decoded.containsKey('data')) {
            final list = (decoded['data'] as List)
                .map((e) => Recipe.fromMap(e as Map<String, dynamic>))
                .toList();
            return list;
          }
        }
        return [];
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching recipes: $e');
      return [];
    }
  }

  Future<Recipe?> getRecipeById(int id) async {
    try {
      final response = await httpService.get('recipes/$id');

      if (response.statusCode == 200) {
        final recipe = Recipe.fromJson(response.body);
        return recipe;
      }
      return null;
    } catch (e) {
      print('Error fetching recipe: $e');
      return null;
    }
  }
}
