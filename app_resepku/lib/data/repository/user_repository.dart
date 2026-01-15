import 'package:app_resepku/data/service/http_service.dart';
import 'package:app_resepku/data/usecase/request/login_request.dart';
import 'package:app_resepku/data/usecase/request/register_request.dart';
import 'package:app_resepku/data/usecase/response/login_response.dart';
import 'package:app_resepku/data/usecase/response/register_response.dart';

class AuthRepository {
  final HttpService httpService;

  AuthRepository(this.httpService);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await httpService.post('login', request.toMap());

    return LoginResponse.fromJson(response.body);
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await httpService.post('register', request.toMap());

    return RegisterResponse.fromJson(response.body);
  }
}
