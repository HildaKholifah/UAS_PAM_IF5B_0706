import 'package:flutter/material.dart';
import 'package:app_resepku/data/model/recipe.dart';

class DetailRecipePage extends StatelessWidget {
  final Recipe recipe;

  const DetailRecipePage({super.key, required this.recipe});

  static const primaryBrown = Color(0xFF6B3E26);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleSection(),
                  const SizedBox(height: 16),
                  _descriptionSection(),
                  const SizedBox(height: 24),
                  _sectionTitle("Bahan"),
                  const SizedBox(height: 8),
                  _ingredientsSection(),
                  const SizedBox(height: 24),
                  _sectionTitle("Langkah Memasak"),
                  const SizedBox(height: 8),
                  _stepsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // APP Bar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFB8792F),
      elevation: 4,
      title: const Text(
        "Detail Resep",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // Image
  Widget _imageSection() {
    if (recipe.imageUrl == null || recipe.imageUrl!.isEmpty) {
      return _imagePlaceholder();
    }

    return Image.network(
      recipe.imageUrl!,
      height: 240,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 240,
      width: double.infinity,
      color: Colors.grey.shade300,
      child: const Icon(Icons.fastfood, size: 80, color: Colors.grey),
    );
  }

  // Title
  Widget _titleSection() {
    return Text(
      recipe.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryBrown,
      ),
    );
  }

  // Description
  Widget _descriptionSection() {
    return Text(
      recipe.description,
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }

  // Section Title
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryBrown,
      ),
    );
  }

  // Ingredients
  Widget _ingredientsSection() {
    if (recipe.ingredients.isEmpty) {
      return const Text(
        "Bahan belum tersedia",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recipe.ingredients.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• "),
              Expanded(child: Text(item, style: const TextStyle(fontSize: 15))),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Steps
  Widget _stepsSection() {
    if (recipe.steps.isEmpty) {
      return const Text(
        "Langkah memasak belum tersedia",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recipe.steps.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final step = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$index. ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Expanded(
                child: Text(
                  step,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
