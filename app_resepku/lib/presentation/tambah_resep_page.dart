import 'package:flutter/material.dart';
import 'package:app_resepku/data/repository/recipe_repository.dart';

class TambahResepPage extends StatefulWidget {
  final String username;
  const TambahResepPage({super.key, required this.username});

  @override
  State<TambahResepPage> createState() => _TambahResepPageState();
}

class _TambahResepPageState extends State<TambahResepPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtr = TextEditingController();
  final _descCtr = TextEditingController();
  final _ingredientCtr = TextEditingController();
  final _stepCtr = TextEditingController();
  final _imageCtr = TextEditingController();

  final RecipeRepository _repository = RecipeRepository();
  bool _isLoading = false;

  static const primaryBrown = Color(0xFF6B3E26);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Resep"),
        backgroundColor: const Color(0xFFB8792F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _inputField(controller: _titleCtr, label: "Judul Resep"),
              const SizedBox(height: 14),

              _inputField(
                controller: _descCtr,
                label: "Deskripsi",
                maxLines: 3,
              ),
              const SizedBox(height: 14),

              _inputField(
                controller: _ingredientCtr,
                label: "Bahan-bahan",
                hint: "Pisahkan dengan baris baru",
                maxLines: 4,
              ),
              const SizedBox(height: 14),

              _inputField(
                controller: _stepCtr,
                label: "Langkah-langkah",
                hint: "Tulis langkah berurutan",
                maxLines: 5,
              ),
              const SizedBox(height: 14),

              _inputField(
                controller: _imageCtr,
                label: "URL Gambar (opsional)",
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBrown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SIMPAN RESEP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (v) =>
          v == null || v.isEmpty ? "$label tidak boleh kosong" : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final success = await _repository.createRecipe(
        title: _titleCtr.text,
        description: _descCtr.text,
        ingredients: _ingredientCtr.text
            .split('\n')
            .where((e) => e.trim().isNotEmpty)
            .toList(),
        steps: _stepCtr.text
            .split('\n')
            .where((e) => e.trim().isNotEmpty)
            .toList(),
        imageUrl: _imageCtr.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Resep berhasil ditambahkan"),
            backgroundColor: Colors.green,
          ),
        );

        // ⬅️ KEMBALI & KIRIM SINYAL SUKSES
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menambah resep: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
