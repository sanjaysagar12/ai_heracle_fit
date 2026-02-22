import 'package:ai_heracle_fit/core/service/auth_service.dart';

class LoginRepository {
  final AuthService _authService = AuthService();

  Future<bool> login(String email) async {
    return await _authService.login(email);
  }
}
