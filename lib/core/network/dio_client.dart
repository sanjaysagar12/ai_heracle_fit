import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ai_heracle_fit/core/network/auth_interceptor.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      final baseUrl = dotenv.env['BACKEND_URL'] ?? '';
      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      _dio!.interceptors.addAll([
        AuthInterceptor(),
        LogInterceptor(requestBody: true, responseBody: true),
      ]);
    }
    return _dio!;
  }
}
