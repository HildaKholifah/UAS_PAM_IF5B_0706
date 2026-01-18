import 'dart:convert';
import 'package:app_resepku/data/model/user.dart';
import 'package:app_resepku/data/service/http_service.dart';

class ProfilRepository {
  final HttpService _http = HttpService();

  Future<User> getProfile() async {
    final response = await _http.get('me');

    if (response.statusCode != 200) {
      throw Exception('HTTP error');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    return User.fromJson(json['user']);
  }
}
