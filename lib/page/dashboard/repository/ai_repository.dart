import 'package:ai_heracle_fit/core/service/heracle_ai_service.dart';
import 'package:ai_heracle_fit/core/models/ai_response.dart';

class AiRepository {
  final HeracleAiService _aiService = HeracleAiService();

  Future<AiResponse> sendMessage(String message) async {
    return await _aiService.sendMessage(message);
  }

  Future<void> clearHistory() async {
    await _aiService.clearHistory();
  }
}
