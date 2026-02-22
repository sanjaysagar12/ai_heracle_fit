import 'package:dio/dio.dart';
import 'package:ai_heracle_fit/core/network/dio_client.dart';
import 'package:ai_heracle_fit/core/models/ai_response.dart';

class HeracleAiApi {
  final Dio _dio = DioClient.instance;

  Future<AiResponse> sendMessage(String message) async {
    final response = await _dio.post(
      '/api/heracle-ai/chat',
      data: {'message': message},
    );

    return AiResponse.fromJson(response.data);
  }

  Future<void> clearHistory() async {
    await _dio.delete('/api/heracle-ai/history');
  }
}
