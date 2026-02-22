import 'package:dio/dio.dart';
import 'package:ai_heracle_fit/core/network/dio_client.dart';

class AuthApi {
  final Dio _dio = DioClient.instance;

  Future<Response> login(String email) async {
    return await _dio.post('/api/auth/dev/token', data: {'email': email});
  }
}
