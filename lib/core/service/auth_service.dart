import 'package:ai_heracle_fit/core/api/auth_api.dart';
import 'package:ai_heracle_fit/core/storage/token_storage.dart';

class AuthService {
  final AuthApi _authApi = AuthApi();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<bool> login(String email) async {
    try {
      final response = await _authApi.login(email);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'];
        if (token != null) {
          await _tokenStorage.saveToken(token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
}
