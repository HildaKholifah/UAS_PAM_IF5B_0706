import 'dart:convert';
import 'dart:io';
import 'package:app_resepku/data/model/recipe.dart';
import 'package:app_resepku/data/service/http_service.dart';
import 'package:app_resepku/data/usecase/response/recipe_response.dart';
import 'package:http/http.dart' as http;

class RecipeRepository {
  final HttpService httpService = HttpService();

  // Ambil semua resep
  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await httpService.get('recipes');
      final decoded = jsonDecode(response.body);
      final recipeResponse = RecipeResponse.fromMap(decoded);
      return recipeResponse.data;
    } catch (e) {
      print('Error getAllRecipes: $e');
      return [];
    }
  }

  // Ambil resep user login
  Future<List<Recipe>> getMyRecipes() async {
    try {
      final response = await httpService.get('recipes/my');
      final decoded = jsonDecode(response.body);

      return (decoded['data'] as List)
          .map((e) => Recipe.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getMyRecipes: $e');
      return [];
    }
  }

  // Tambah resep (WAJIB FILE)
  Future<bool> createRecipe({
    required String title,
    required String description,
    required List<String> ingredients,
    required List<String> steps,
    required File imageFile,
  }) async {
    final headers = await httpService.getHeaders();

    final uri = Uri.parse('${httpService.baseUrl}recipes');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['ingredients'] = jsonEncode(ingredients);
    request.fields['steps'] = jsonEncode(steps);

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print('CREATE RECIPE STATUS: ${response.statusCode}');
    print('CREATE RECIPE BODY: $body');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(body);
    }
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:app_resepku/data/model/recipe.dart';
// import 'package:app_resepku/data/service/http_service.dart';
// import 'package:app_resepku/data/usecase/response/recipe_response.dart';
// import 'package:http/http.dart' as http;

// class RecipeRepository {
//   final HttpService httpService = HttpService();

//   // Ambil semua resep
//   Future<List<Recipe>> getAllRecipes() async {
//     try {
//       final headers = await httpService.getHeaders();
//       final response = await httpService.get('recipes', headers: headers);
//       final decoded = jsonDecode(response.body);
//       final recipeResponse = RecipeResponse.fromMap(decoded);
//       return recipeResponse.data;
//     } catch (e) {
//       print('Error getAllRecipes: $e');
//       return [];
//     }
//   }

//   // Ambil resep user
//   Future<List<Recipe>> getMyRecipes() async {
//     try {
//       final headers = await httpService.getHeaders();
//       final response = await httpService.get('recipes/my', headers: headers);
//       final decoded = jsonDecode(response.body);
//       return (decoded['data'] as List)
//           .map((e) => Recipe.fromMap(e as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       print('Error getMyRecipes: $e');
//       return [];
//     }
//   }

//   // Tambah resep wajib pakai file
//   Future<bool> createRecipe({
//     required String title,
//     required String description,
//     required List<String> ingredients,
//     required List<String> steps,
//     required File imageFile, // file wajib
//   }) async {
//     final headers = await httpService.getHeaders();

//     final uri = Uri.parse('${httpService.baseUrl}recipes');
//     final request = http.MultipartRequest('POST', uri);
//     request.headers.addAll(headers);

//     // Tambahkan field
//     request.fields['title'] = title;
//     request.fields['description'] = description;
//     request.fields['ingredients'] = jsonEncode(ingredients);
//     request.fields['steps'] = jsonEncode(steps);

//     // Tambahkan file
//     request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

//     // Kirim request
//     final response = await request.send();
//     final responseBody = await response.stream.bytesToString();

//     print('CREATE RECIPE STATUS: ${response.statusCode}');
//     print('CREATE RECIPE BODY: $responseBody');

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return true;
//     } else {
//       throw Exception(responseBody);
//     }
//   }
// }
