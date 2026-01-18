import 'dart:convert';
import 'dart:io';
import 'package:app_resepku/data/model/recipe.dart';
import 'package:app_resepku/data/service/http_service.dart';
import 'package:app_resepku/data/usecase/response/recipe_response.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
    final compressedImage = await compressImage(imageFile);

    final uri = Uri.parse('${httpService.baseUrl}recipes');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);

    request.fields['title'] = title;
    request.fields['description'] = description;
    // request.fields['ingredients'] = jsonEncode(ingredients);
    for (int i = 0; i < ingredients.length; i++) {
      request.fields['ingredients[$i]'] = ingredients[i];
    }
    // request.fields['steps'] = jsonEncode(steps);
    for (int i = 0; i < steps.length; i++) {
      request.fields['steps[$i]'] = steps[i];
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        compressedImage.path,
      ),
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

  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60,        // ⬅️ PENTING
      minWidth: 1024,     // ⬅️ PENTING
      minHeight: 1024,    // ⬅️ PENTING
    );

    if (result == null) throw Exception('Gagal kompres gambar');

    return File(result.path);
  }
}
