import 'package:flutter/material.dart';
import 'package:app_resepku/data/repository/recipe_repository.dart';
import 'package:app_resepku/data/model/recipe.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage(String s, {super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late RecipeRepository _recipeRepository;
  late Future<List<Recipe>> _recipesFuture;

  static const primaryBrown = Color(0xFF6B3E26);

  @override
  void initState() {
    super.initState();
    _recipeRepository = RecipeRepository();
    _recipesFuture = _recipeRepository.getAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _greetingText(),
            const SizedBox(height: 30),
            _sectionTitle(),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: _recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "Belum ada resep tersedia",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    );
                  }

                  final recipes = snapshot.data!;
                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return _recipeCard(recipe);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryBrown,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Resep Saya"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Penilaian"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }

  // App Bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFFB8792F),
      elevation: 6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      centerTitle: true,
      title: const Text(
        "ResepKu",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset("assets/Logo_ResepKu.png"),
        ),
      ),
    );
  }

  // Greeting
  Widget _greetingText() {
    return Text(
      "Halo, ${widget.username} 👋",
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: primaryBrown,
      ),
    );
  }

  // Recipe Section
  Widget _sectionTitle() {
    return const Text(
      "Rekomendasi Resep",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }

  Widget _recipeCard(Recipe recipe) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                recipe.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
