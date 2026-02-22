import 'package:dio/dio.dart';
import 'package:ai_heracle_fit/core/network/dio_client.dart';
import 'package:ai_heracle_fit/core/models/ai_response.dart';

class HeracleAiApi {
  final Dio _dio = DioClient.instance;

  Future<List<AiResponse>> sendMessage(String message) async {
    final response = await _dio.post(
      '/api/heracle-ai/chat',
      data: {'message': message},
    );

    if (response.data is List) {
      return (response.data as List)
          .map((item) => AiResponse.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.data is Map) {
      return [AiResponse.fromJson(response.data as Map<String, dynamic>)];
    }

    return [];
  }

  Future<void> clearHistory() async {
    await _dio.delete('/api/heracle-ai/history');
  }
}
