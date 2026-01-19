import 'package:app_resepku/data/model/recipe.dart';
import 'package:app_resepku/data/repository/recipe_repository.dart';
import 'package:flutter/material.dart';

class ResepFavoritPage extends StatefulWidget {
  const ResepFavoritPage({super.key});

  @override
  State<ResepFavoritPage> createState() => _ResepFavoritPageState();
}

class _ResepFavoritPageState extends State<ResepFavoritPage> {
  final RecipeRepository _repo = RecipeRepository();
  List<Recipe> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final fav = await _repo.getMyFavorites();
    setState(() {
      _favorites = fav;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_favorites.isEmpty)
      return const Center(child: Text('Belum ada favorit'));

    return ListView.builder(
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final recipe = _favorites[index];
        return ListTile(
          title: Text(recipe.title),
          leading: recipe.imageUrl != null
              ? Image.network(recipe.imageUrl!)
              : const Icon(Icons.fastfood),
        );
      },
    );
  }
}
