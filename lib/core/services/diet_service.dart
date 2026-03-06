import 'package:ai_heracle_fit/core/models/diet_preferences.dart';
import 'package:ai_heracle_fit/core/models/logged_meal.dart';
import 'package:ai_heracle_fit/core/models/diet_status.dart';
import 'package:ai_heracle_fit/core/models/tracked_food.dart';
import 'package:ai_heracle_fit/core/models/diet_suggestion.dart';
import 'package:ai_heracle_fit/core/services/api_client.dart';
import 'package:intl/intl.dart';

class DietService {
  DietService._();
  static final DietService instance = DietService._();

  /// GET /diet/today
  /// Returns null when the user has no diet plan yet.
  Future<DietSuggestion?> fetchTodayDiet() async {
    try {
      final response = await ApiClient.instance.get('/diet/today');
      if (response.statusCode == 204 || response.data == null) return null;
      if (response.statusCode == 200) {
        final raw = response.data;
        if (raw is Map<String, dynamic>) {
          return DietSuggestion.fromJson(raw);
        }
      }
    } catch (e) {
      print('[DietService] fetchTodayDiet error: $e');
    }
    return null;
  }

  /// POST /diet/preferences
  Future<bool> savePreferences(DietPreferences prefs) async {
    try {
      final response = await ApiClient.instance.post(
        '/diet/preferences',
        data: prefs.toJson(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DietService] savePreferences error: $e');
      return false;
    }
  }

  /// POST /diet/ai/food
  /// Analyzes a food description using AI.
  Future<TrackedFood?> analyzeFood(String description) async {
    try {
      final response = await ApiClient.instance.post(
        '/diet/ai/food',
        data: {'description': description},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return TrackedFood.fromJson(data);
        }
      }
    } catch (e) {
      print('[DietService] analyzeFood error: $e');
    }
    return null;
  }

  /// POST /diet/meal
  Future<LoggedMeal?> logMeal(LoggedMeal meal) async {
    try {
      final response = await ApiClient.instance.post(
        '/diet/meal',
        data: meal.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return LoggedMeal.fromJson(data);
        }
      }
    } catch (e) {
      print('[DietService] logMeal error: $e');
    }
    return null;
  }

  /// GET /diet/meals
  /// [date] defaults to today (YYYY-MM-DD)
  Future<List<LoggedMeal>> fetchMeals([String? date]) async {
    try {
      final queryDate = date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await ApiClient.instance.get(
        '/diet/meals',
        queryParameters: {'date': queryDate},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data
              .map((e) => LoggedMeal.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      print('[DietService] fetchMeals error: $e');
    }
    return [];
  }

  /// GET /diet/status
  Future<DietStatus?> fetchDietStatus([String? date]) async {
    try {
      final queryDate = date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await ApiClient.instance.get(
        '/diet/status',
        queryParameters: {'date': queryDate},
      );
      if (response.statusCode == 200) {
        return DietStatus.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      print('[DietService] fetchDietStatus error: $e');
    }
    return null;
  }
}
