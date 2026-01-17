import 'dart:convert';
import 'package:app_resepku/data/model/user.dart';
import 'package:app_resepku/data/service/http_service.dart';

class ProfilRepository {
  final HttpService httpService = HttpService();

  Future<User> getProfile() async {
    final res = await httpService.get('user');

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final data = json['data'];
      return User.fromMap(data);
    } else {
      throw Exception('Profil gagal dimuat');
    }
  }
}
