import 'dart:convert';
import 'package:app_resepku/data/model/recipe.dart';
import 'package:app_resepku/data/service/http_service.dart';
import 'package:app_resepku/data/service/token_storage.dart';
import 'package:app_resepku/data/usecase/response/recipe_response.dart';

class RecipeRepository {
  final HttpService httpService = HttpService();
  final TokenStorage tokenStorage = TokenStorage();

  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await httpService.get('recipes');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final decoded = jsonDecode(response.body);
      print('Decoded: $decoded');

      final recipeResponse = RecipeResponse.fromMap(decoded);
      print('Total recipes: ${recipeResponse.data.length}');
      return recipeResponse.data;
    } catch (e) {
      print('Error getAllRecipes: $e');
      return [];
    }
  }

  Future<List<Recipe>> getMyRecipes() async {
    final response = await httpService.get('recipes/my');

    print('MY RECIPES RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return (decoded['data'] as List).map((e) => Recipe.fromMap(e)).toList();
    }
    return [];
  }

  Future<bool> createRecipe({
    required String title,
    required String description,
    required List<String> ingredients,
    required List<String> steps,
    required String imageUrl,
  }) async {
    final response = await httpService.post('recipes', {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'image_url': imageUrl,
    });

    print('CREATE RECIPE STATUS: ${response.statusCode}');
    print('CREATE RECIPE BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(response.body);
    }
  }
}
