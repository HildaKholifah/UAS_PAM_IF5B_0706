import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class HttpService {
  final String baseUrl = "http://10.16.43.198:8000/api/";
  final TokenStorage tokenStorage = TokenStorage();

  // PUBLIK (BUKAN PRIVATE)
  Future<Map<String, String>> getHeaders() async {
    final token = await tokenStorage.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();

    final response = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 30));

    log('GET $endpoint => ${response.statusCode}');
    log(response.body);
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http
        .post(url, headers: headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 40));

    log('POST $endpoint => ${response.statusCode}');
    log(response.body);
    return response;
  }
}