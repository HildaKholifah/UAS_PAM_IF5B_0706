import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl = "http://10.72.255.207:8000/api/";
  // diganti 10.0.2.2 (api emulator),
  // kalo menggunakan device asli ganti ke ip komputer lokal dan memakai wifi yang sama
  // gunakan IPv4 Address: (cara cek nya ipconfig)

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException(
              'Request timeout after 10 seconds',
              const Duration(seconds: 10),
            ),
          );
      log('GET Response: ${response.body}');
      return response;
    } on TimeoutException {
      log('GET timeout for endpoint: $endpoint');
      rethrow;
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: json.encode(body),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException(
              'Request timeout after 10 seconds',
              const Duration(seconds: 10),
            ),
          );
      log('POST Response: ${response.body}');
      return response;
    } on TimeoutException {
      log('POST timeout for endpoint: $endpoint');
      rethrow;
    }
  }

  Future<http.Response> postWithFile(
    String endPoint,
    Map<String, String> fields,
    File? file,
    String fileFieldName,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endPoint');
      final request = http.MultipartRequest('POST', url);

      // Add fields
      request.fields.addAll(fields);

      // Add file if available
      if (file != null) {
        final imageFile = await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
        );
        request.files.add(imageFile);
        log('File added: ${file.path}');
      }

      log('POST with File to: $url');
      log('Fields: ${request.fields}');
      log('Files: ${request.files.length}');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      log('POST with File Response: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('Error in postWithFile: $e');
      rethrow;
    }
  }

  Future<http.Response> put(String endPoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );
    log('PUT Response: ${response.body}');
    return response;
  }

  Future<http.Response> delete(String endPoint) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }
}
