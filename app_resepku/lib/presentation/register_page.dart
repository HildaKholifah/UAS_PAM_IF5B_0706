import 'package:app_resepku/data/repository/user_repository.dart';
import 'package:app_resepku/data/usecase/request/register_request.dart';
import 'package:app_resepku/presentation/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _passCtr = TextEditingController();
  final _confirmCtr = TextEditingController();

  final userRepository = UserRepository();

  @override
  void dispose() {
    _nameCtr.dispose();
    _emailCtr.dispose();
    _passCtr.dispose();
    _confirmCtr.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await userRepository.register(
      RegisterRequest(
        name: _nameCtr.text,
        email: _emailCtr.text,
        password: _passCtr.text,
        passwordConfirmation: _confirmCtr.text,
      ),
    );

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtr,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtr,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    v == null || !v.contains('@') ? 'Email tidak valid' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passCtr,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) =>
                    v == null || v.length < 8 ? 'Minimal 8 karakter' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmCtr,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                ),
                obscureText: true,
                validator: (v) =>
                    v != _passCtr.text ? 'Password tidak sama' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text('DAFTAR')),
            ],
          ),
        ),
      ),
    );
  }
}
