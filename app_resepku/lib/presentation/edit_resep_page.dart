import 'dart:io';

import 'package:app_resepku/data/model/recipe.dart';
import 'package:app_resepku/data/repository/recipe_repository.dart';
import 'package:flutter/material.dart';

class EditResepPage extends StatefulWidget {
  final Recipe recipe;
  const EditResepPage({super.key, required this.recipe});

  @override
  State<EditResepPage> createState() => _EditResepPageState();
}

class _EditResepPageState extends State<EditResepPage> {
  late TextEditingController titleCtr;
  late TextEditingController descCtr;
  late TextEditingController ingredientCtr;
  late TextEditingController stepCtr;

  final RecipeRepository recipeRepository = RecipeRepository();
  File? imageFile;

  @override
  void initState() {
    super.initState();
    titleCtr = TextEditingController(text: widget.recipe.title);
    descCtr = TextEditingController(text: widget.recipe.description);
    ingredientCtr = TextEditingController(
      text: widget.recipe.ingredients.join('\n'),
    );
    stepCtr = TextEditingController(text: widget.recipe.steps.join('\n'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Resep")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleCtr),
            TextField(controller: descCtr),
            TextField(controller: ingredientCtr, maxLines: 4),
            TextField(controller: stepCtr, maxLines: 4),

            ElevatedButton(
              child: const Text("Simpan Perubahan"),
              onPressed: () async {
                await recipeRepository.updateRecipe(
                  id: widget.recipe.id,
                  title: titleCtr.text,
                  description: descCtr.text,
                  ingredients: ingredientCtr.text.split('\n'),
                  steps: stepCtr.text.split('\n'),
                );
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
