import 'dart:convert';
import 'package:app_resepku/data/model/user.dart';
import 'package:app_resepku/data/service/http_service.dart';
import 'package:app_resepku/data/service/token_storage.dart';

class ProfilRepository {
  final HttpService httpService = HttpService();
  final tokenStorage = TokenStorage();

  Future<User> getProfile() async {
    final token = await tokenStorage.getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final res = await httpService.get('user');

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final data = json['user'];
      return User.fromMap(data);
    } else {
      throw Exception('Profil gagal dimuat');
    }
  }
}
