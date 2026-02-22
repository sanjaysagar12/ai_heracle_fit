import 'package:ai_heracle_fit/core/api/heracle_ai_api.dart';
import 'package:ai_heracle_fit/core/models/ai_response.dart';

class HeracleAiService {
  final HeracleAiApi _aiApi = HeracleAiApi();

  Future<AiResponse> sendMessage(String message) async {
    return await _aiApi.sendMessage(message);
  }

  Future<void> clearHistory() async {
    await _aiApi.clearHistory();
  }
}
