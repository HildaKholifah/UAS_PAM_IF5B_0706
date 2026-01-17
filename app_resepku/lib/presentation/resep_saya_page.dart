import 'package:app_resepku/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:app_resepku/data/model/recipe.dart';
import 'package:app_resepku/data/repository/recipe_repository.dart';
import 'package:app_resepku/presentation/detail_resep_page.dart';

class ResepSayaPage extends StatefulWidget {
  final String username;

  const ResepSayaPage({super.key, required this.username});

  @override
  State<ResepSayaPage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<ResepSayaPage> {
  final RecipeRepository _repository = RecipeRepository();

  bool _isLoading = true;
  List<Recipe> _recipes = [];

  int _selectedIndex = 1;
  static const primaryBrown = Color(0xFF6B3E26);

  @override
  void initState() {
    super.initState();
    _loadMyRecipes();
  }

  Future<void> _loadMyRecipes() async {
    try {
      // Ambil resep milik user yang login
      final myRecipes = await _repository.getMyRecipes();

      setState(() {
        _recipes = myRecipes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading my recipes: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBrown,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HomePage(username: 'Hilda'),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // APP Bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFB8792F),
      centerTitle: true,
      title: const Text(
        "Resep Saya",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Content
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_recipes.isEmpty) {
      return const Center(
        child: Text(
          "Kamu belum menambahkan resep.\nKlik + untuk menambah.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recipes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return _recipeCard(_recipes[index]);
      },
    );
  }

  // Card
  Widget _recipeCard(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailRecipePage(recipe: recipe)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: recipe.imageUrl != null
                    ? Image.network(
                        recipe.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                recipe.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: primaryBrown,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == _selectedIndex) return;

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(username: widget.username),
            ),
          );
        }

        if (index == 2) {
          // NANTI: RatingPage
        }

        if (index == 3) {
          // NANTI: ProfilePage
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: "Resep Saya"),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: "Penilaian"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(child: Icon(Icons.fastfood, size: 40)),
    );
  }
}
