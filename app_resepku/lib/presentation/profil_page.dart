import 'package:app_resepku/presentation/home_page.dart';
import 'package:app_resepku/presentation/resep_saya_page.dart';
import 'package:flutter/material.dart';
import 'package:app_resepku/data/repository/profil_repository.dart';
import 'package:app_resepku/data/model/user.dart';
import 'package:app_resepku/data/repository/user_repository.dart';
import 'package:app_resepku/presentation/login_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final ProfilRepository _profileRepo = ProfilRepository();
  final UserRepository _userRepo = UserRepository();

  late Future<User> _profileFuture;
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _profileFuture = _profileRepo.getProfile();
  }

  // Dialog logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _userRepo.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Navigasi tab
  void _onNavTap(int index) {
    // if (index == _selectedIndex) return;

    // if (index == 0) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (_) => const HomePage(username: 'User')),
    //   );
    // } else if (index == 1) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (_) => const ResepSayaPage(username: 'User'),
    //     ),
    //   );
    // }

    setState(() => _selectedIndex = index);
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<User>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6B3E26),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Resep Saya'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Rating'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
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
          backgroundColor: Color(0xFF6B3E26),
          child: const Icon(Icons.person, size: 60, color: Colors.white),
        ),

        const SizedBox(height: 16),

        // Name
        Text(
          user.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        // Email
        Text(user.email, style: const TextStyle(color: Colors.black54)),

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
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "LOGOUT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _showLogoutDialog,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(title: Text(label), subtitle: Text(value)),
      ),
    );
  }
}
