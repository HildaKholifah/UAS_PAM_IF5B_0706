import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'token_storage.dart';

class HttpService {
  final String baseUrl = "http://192.168.100.56:8000/api/";
  // Menggunakan adb reverse - emulator ke host machine
  // Jalankan: adb reverse tcp:8000 tcp:8000

  final tokenStorage = TokenStorage();

  Future<Map<String, String>> _headers() async {
    final token = await tokenStorage.getToken();
    print("TOKEN DI HEADER: $token");

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers();

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      log('GET $endpoint => ${response.statusCode}');
      log(response.body);
      return response;
    } on TimeoutException catch (e) {
      log('❌ Timeout on GET $endpoint: $e');
      rethrow;
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _headers();

    final response = await http
        .post(url, headers: headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 60));

    log('POST $endpoint => ${response.statusCode}');
    log(response.body);
    return response;
  }

  Future<http.Response> postWithFile(
    String endpoint,
    Map<String, String> fields,
    File? file,
    String fileFieldName,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', url);

    // 🔐 AUTH HEADER
    // final token = await tokenStorage.getToken();
    // if (token != null) {
    //   request.headers['Authorization'] = 'Bearer $token';
    // }

    request.fields.addAll(fields);

    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath(fileFieldName, file.path),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    log('POST FILE $endpoint => ${response.statusCode}');
    log(response.body);
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _headers();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    log('PUT $endpoint => ${response.statusCode}');
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _headers();

    final response = await http.delete(url, headers: headers);
    log('DELETE $endpoint => ${response.statusCode}');
    return response;
  }
}
