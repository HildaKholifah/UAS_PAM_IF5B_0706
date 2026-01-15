import 'dart:convert';
import 'package:app_resepku/data/model/user.dart';

class RegisterResponse {
  final String status;
  final String message;
  final User user;

  RegisterResponse({
    required this.status,
    required this.message,
    required this.user,
  });

  factory RegisterResponse.fromJson(String str) =>
      RegisterResponse.fromMap(json.decode(str));

  factory RegisterResponse.fromMap(Map<String, dynamic> json) =>
      RegisterResponse(
        status: json["status"],
        message: json["message"],
        user: User.fromMap(json["user"]),
      );
}
