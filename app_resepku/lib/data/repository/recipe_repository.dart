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
    try {
      final userId = await tokenStorage.getUserId();
      if (userId == null) {
        print('User ID not found');
        return [];
      }

      final allRecipes = await getAllRecipes();
      final myRecipes = allRecipes
          .where((recipe) => recipe.userId == userId)
          .toList();

      print('Total my recipes: ${myRecipes.length}');
      return myRecipes;
    } catch (e) {
      print('Error getMyRecipes: $e');
      return [];
    }
  }
}
