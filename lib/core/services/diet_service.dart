import 'dart:convert';
import 'package:ai_heracle_fit/core/models/diet_preferences.dart';
import 'package:ai_heracle_fit/core/services/api_client.dart';

class DietService {
  DietService._();
  static final DietService instance = DietService._();

  /// GET /api/diet/today
  /// Returns null when the user has no diet plan yet.
  Future<Map<String, dynamic>?> fetchTodayDiet() async {
    try {
      final response = await ApiClient.instance.get('/api/diet/today');
      if (response.statusCode == 204 || response.data == null) return null;
      if (response.statusCode == 200) {
        final raw = response.data;
        if (raw is Map) return Map<String, dynamic>.from(raw);
        if (raw is String) {
          final decoded = jsonDecode(raw);
          if (decoded is Map) return Map<String, dynamic>.from(decoded);
        }
      }
    } catch (e) {
      print('[DietService] fetchTodayDiet error: $e');
    }
    return null;
  }

  /// POST /api/diet/preferences
  Future<bool> savePreferences(DietPreferences prefs) async {
    try {
      final response = await ApiClient.instance.post(
        '/api/diet/preferences',
        data: prefs.toJson(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DietService] savePreferences error: $e');
      return false;
    }
  }
}
