import 'package:flutter/material.dart';
import 'package:app_resepku/data/repository/profil_repository.dart';
import 'package:app_resepku/data/model/user.dart';
import 'package:app_resepku/data/repository/user_repository.dart';
import 'package:app_resepku/presentation/login_page.dart';

class ProfilPage extends StatelessWidget {
  ProfilPage({super.key});

  final ProfileRepository _profileRepo = ProfileRepository();
  final UserRepository _userRepo = UserRepository();

  static const primaryBrown = Color(0xFF6B3E26);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8792F),
        centerTitle: true,
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<User>(
        future: _profileRepo.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Gagal memuat profil",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final user = snapshot.data!;
          return _profileContent(context, user);
        },
      ),
    );
  }

  Widget _profileContent(BuildContext context, User user) {
    return Column(
      children: [
        const SizedBox(height: 30),

        // Avatar
        CircleAvatar(
          radius: 55,
          backgroundColor: primaryBrown,
          child: const Icon(Icons.person, size: 60, color: Colors.white),
        ),

        const SizedBox(height: 16),

        // Name
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        // Email
        Text(
          user.email,
          style: const TextStyle(color: Colors.black54),
        ),

        const SizedBox(height: 30),

        // Info Card
        _infoTile("ID User", user.id.toString()),
        _infoTile("Dibuat", user.createdAt.toString().substring(0, 10)),

        const Spacer(),

        // Logout
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text(
                "LOGOUT",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                await _userRepo.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (_) => false,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(label),
          subtitle: Text(value),
        ),
      ),
    );
  }
}
