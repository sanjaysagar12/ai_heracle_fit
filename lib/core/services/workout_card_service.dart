import 'dart:convert';
import 'package:ai_heracle_fit/core/models/workout_card_data.dart';
import 'package:ai_heracle_fit/core/services/api_client.dart';

class WorkoutCardService {
  WorkoutCardService._();
  static final WorkoutCardService instance = WorkoutCardService._();

  /// GET /api/workout/today
  ///
  /// Returns [WorkoutCardData.newUser] when the server returns null
  /// (new user with no plan yet) or on any network/parse error.
  Future<WorkoutCardData> fetchTodayCard() async {
    try {
      final response = await ApiClient.instance.get('/api/workout/today');

      // 204 No Content or explicit null body → new user
      if (response.statusCode == 204 || response.data == null) {
        print('[WorkoutCardService] No workout data — treating as new user.');
        return WorkoutCardData.newUser;
      }

      if (response.statusCode == 200) {
        final data = _toMap(response.data);
        if (data == null) return WorkoutCardData.newUser;
        return WorkoutCardData.fromJson(data);
      }

      print('[WorkoutCardService] Unexpected status ${response.statusCode}');
    } catch (e) {
      print('[WorkoutCardService] Error fetching today card: $e');
    }

    return WorkoutCardData.newUser;
  }

  /// Safely converts [raw] to a [Map<String, dynamic>].
  /// Handles both pre-decoded Maps and raw JSON strings.
  Map<String, dynamic>? _toMap(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }
}
