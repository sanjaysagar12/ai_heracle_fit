import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Top-level constant — shared by ApiClient and _AuthInterceptor
const String _jwtKey = 'backend_jwt';

/// Singleton Dio client that automatically attaches the backend JWT
/// as a Bearer token to every outgoing request.
///
/// Usage anywhere in the app:
///   final response = await ApiClient.instance.get('/workouts');
class ApiClient {
  ApiClient._();

  static const _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://ai-heracle-backend.vercel.app',
  );

  static final ApiClient _singleton = ApiClient._();
  static ApiClient get instance => _singleton;

  late final Dio _dio = _buildDio();

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(_AuthInterceptor());
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[ApiClient] $obj'),
      ),
    );

    return dio;
  }

  // ── Convenience delegates ─────────────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.get(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(String path, {dynamic data, Options? options}) =>
      _dio.post(path, data: data, options: options);

  Future<Response<T>> put<T>(String path, {dynamic data, Options? options}) =>
      _dio.put(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) => _dio.delete(path, data: data, options: options);

  Future<Response<T>> patch<T>(String path, {dynamic data, Options? options}) =>
      _dio.patch(path, data: data, options: options);

  /// POST without attaching a JWT — used for the initial auth token exchange.
  /// Returns null on network error instead of throwing.
  Future<Map<String, dynamic>?> postUnauthenticated(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final unauthDio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      final response = await unauthDio.post(path, data: data);
      return response.data as Map<String, dynamic>?;
    } on DioException catch (e) {
      print('[ApiClient] Network error on $path: ${e.message}');
      return null;
    }
  }

  /// Expose raw authenticated Dio for edge cases (e.g. multipart uploads).
  Dio get raw => _dio;
}

// ── Auth Interceptor ──────────────────────────────────────────────────────────

class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString(_jwtKey);

    if (jwt != null && jwt.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $jwt';
      print('[ApiClient] Attached JWT to ${options.method} ${options.path}');
    } else {
      print('[ApiClient] No JWT found — sending unauthenticated request.');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      print('[ApiClient] 401 Unauthorized — JWT may be expired.');
      // TODO: trigger re-login or token refresh here if needed
    }
    handler.next(err);
  }
}
