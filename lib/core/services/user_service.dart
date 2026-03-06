import 'package:ai_heracle_fit/core/models/user_profile.dart';
import 'package:ai_heracle_fit/core/models/onboarding_status.dart';
import 'package:ai_heracle_fit/core/services/api_client.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();

  // In-memory cache for onboarding status — avoids repeat network calls.
  OnboardingStatus? _cachedOnboardingStatus;

  /// Clears the cached onboarding status so the next call fetches fresh data.
  void clearOnboardingCache() => _cachedOnboardingStatus = null;

  Future<UserProfile?> fetchProfile() async {
    try {
      final response = await ApiClient.instance.get('/user/profile');

      if (response.statusCode == 200 && response.data != null) {
        return UserProfile.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
      }
      print('[UserService] Unexpected status: ${response.statusCode}');
      return null;
    } catch (e) {
      print('[UserService] Failed to fetch profile: $e');
      return null;
    }
  }

  Future<OnboardingStatus?> fetchOnboardingStatus() async {
    // Return cached value if available — no extra network call.
    if (_cachedOnboardingStatus != null) {
      return _cachedOnboardingStatus;
    }

    try {
      final response = await ApiClient.instance.get('/user/onboarding-status');

      if (response.statusCode == 200 && response.data != null) {
        _cachedOnboardingStatus = OnboardingStatus.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
        return _cachedOnboardingStatus;
      }
      print('[UserService] Unexpected status: ${response.statusCode}');
      return null;
    } catch (e) {
      print('[UserService] Failed to fetch onboarding status: $e');
      return null;
    }
  }
}
