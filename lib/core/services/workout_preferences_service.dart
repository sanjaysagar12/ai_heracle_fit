import 'package:ai_heracle_fit/core/models/workout_preferences.dart';
import 'package:ai_heracle_fit/core/services/api_client.dart';

class WorkoutPreferencesService {
  WorkoutPreferencesService._();
  static final WorkoutPreferencesService instance =
      WorkoutPreferencesService._();

  /// POST /workout/preferences
  /// Returns true on success.
  Future<bool> savePreferences(WorkoutPreferences prefs) async {
    try {
      final response = await ApiClient.instance.post(
        '/workout/preferences',
        data: prefs.toJson(),
      );

      final success = response.statusCode == 200 || response.statusCode == 201;
      if (success) {
        print('[WorkoutPreferencesService] Preferences saved successfully.');
      } else {
        print(
          '[WorkoutPreferencesService] Unexpected status ${response.statusCode}: ${response.data}',
        );
      }
      return success;
    } catch (e) {
      print('[WorkoutPreferencesService] Error saving preferences: $e');
      return false;
    }
  }
}
