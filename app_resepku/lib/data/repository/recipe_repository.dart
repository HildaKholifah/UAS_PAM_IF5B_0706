import 'package:app_resepku/data/model/recipe.dart';
import 'package:app_resepku/data/service/http_service.dart';

class RecipeRepository {
  final HttpService httpService = HttpService();

  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await httpService.get('recipes');
      
      if (response.statusCode == 200) {
        final jsonBody = response.body;
        
        // Parse response berdasarkan struktur API
        // Bisa berupa List langsung atau {data: [...]}
        if (jsonBody is String) {
          final decoded = jsonBody;
          // Jika response adalah array langsung
          if (decoded.startsWith('[')) {
            final list = (decoded as List).map((e) => Recipe.fromMap(e as Map<String, dynamic>)).toList();
            return list;
          } else {
            // Jika response adalah object dengan key 'data'
            final map = decoded as Map<String, dynamic>;
            final list = (map['data'] as List).map((e) => Recipe.fromMap(e as Map<String, dynamic>)).toList();
            return list;
          }
        }
        return [];
      } else {
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
