import 'package:app_resepku/data/service/token_storage.dart';
import 'package:app_resepku/presentation/login_page.dart';
import 'package:app_resepku/presentation/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> isLogin() async {
    final token = await TokenStorage().getToken();
    return token != null;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResepKu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        // '/home': (_) => const HomePage(),
      },
      home: FutureBuilder<bool>(
        future: isLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data! ? const RegisterPage() : const LoginPage();
        },
      ),
    );
  }
}
