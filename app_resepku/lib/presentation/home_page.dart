import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username;
  const HomePage(String s, {super.key, required this.username});

  static const primaryBrown = Color(0xFF6B3E26);

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
            const SizedBox(height: 24),
            _sectionTitle(),
            const SizedBox(height: 12),
            Expanded(child: _recipeListSection()),
            const SizedBox(height: 24),
            _menuSection(context),
          ],
        ),
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
          child: Image.asset("assets/Logo_Resepku.png"),
        ),
      ),
    );
  }

  // Greeting
  Widget _greetingText() {
    return Text(
      "Halo, $username 👋",
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: primaryBrown,
      ),
    );
  }

  // Menu
  Widget _menuSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _menuCard(
              icon: Icons.home,
              label: "Home",
              colors: [primaryBrown, Colors.brown],
              onTap: () {},
            ),
            _menuCard(
              icon: Icons.book,
              label: "Resep Saya",
              colors: [Colors.orange, Colors.deepOrange],
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _menuCard(
              icon: Icons.star,
              label: "Penilaian",
              colors: [Colors.amber, Colors.orangeAccent],
              onTap: () {},
            ),
            _menuCard(
              icon: Icons.person,
              label: "Akun",
              colors: [Colors.blueGrey, Colors.grey],
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
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

  Widget _recipeListSection() {
    return ListView(
      shrinkWrap: true,
      children: [
        _recipeCard(
          title: "Nasi Goreng",
          image: "assets/nasi_goreng.jpg",
        ),
        const SizedBox(height: 12),
        _recipeCard(
          title: "Gado-Gado",
          image: "assets/gado_gado.jpg",
        ),
      ],
    );
  }

  Widget _recipeCard({
    required String title,
    required String image,
  }) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              image,
              width: 140,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 140,
                  height: 160,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 40),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text(
                        "4.5 (120 ulasan)",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBrown,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                    child: const Text(
                      "Lihat",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
