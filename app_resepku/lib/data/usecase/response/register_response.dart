import 'dart:convert';
import '../../model/user.dart';

class RegisterResponse {
  final bool success;
  final String message;
  final RegisterData? data;

  RegisterResponse({required this.success, required this.message, this.data});

  factory RegisterResponse.fromJson(String str) =>
      RegisterResponse.fromMap(json.decode(str));

  factory RegisterResponse.fromMap(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? RegisterData.fromMap(json['data']) : null,
    );
  }
}

class RegisterData {
  final User user;
  final String token;

  RegisterData({required this.user, required this.token});

  factory RegisterData.fromMap(Map<String, dynamic> json) {
    return RegisterData(user: User.fromMap(json['user']), token: json['token']);
  }
}
