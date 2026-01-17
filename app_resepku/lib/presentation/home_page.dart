import 'package:flutter/material.dart';
import 'package:app_resepku/data/model/recipe.dart';
import 'package:app_resepku/data/repository/recipe_repository.dart';

// VIEW MODEL
class HomeViewModel extends ChangeNotifier {
  final RecipeRepository repository;

  HomeViewModel(this.repository);

  bool isLoading = false;
  String? errorMessage;
  List<Recipe> recipes = [];

  Future<void> fetchRecipes() async {
    try {
      isLoading = true;
      notifyListeners();

      recipes = await repository.getAllRecipes();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

// UI
class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late HomeViewModel viewModel;

  static const primaryBrown = Color(0xFF6B3E26);

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel(RecipeRepository());
    viewModel.fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: viewModel,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _greetingText(),
                const SizedBox(height: 30),
                _sectionTitle(),
                const SizedBox(height: 12),
                Expanded(child: _buildContent()),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // CONTENT STATE
  Widget _buildContent() {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(child: Text(viewModel.errorMessage!));
    }

    if (viewModel.recipes.isEmpty) {
      return Center(
        child: Text(
          "Belum ada resep tersedia",
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.recipes.length,
      itemBuilder: (context, index) {
        return _recipeCard(viewModel.recipes[index]);
      },
    );
  }

  // UI COMPONENTS
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFB8792F),
      elevation: 6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      centerTitle: true,
      title: const Text(
        "ResepKu",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
          if (recipe.imageUrl?.isNotEmpty == true)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                recipe.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imageError(),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageError() {
    return Container(
      height: 200,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported),
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: primaryBrown,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: "Resep Saya"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}
