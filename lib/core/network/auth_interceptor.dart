import 'package:dio/dio.dart';
import 'package:ai_heracle_fit/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized (e.g., clear token, logout user)
    }
    return handler.next(err);
  }
}
