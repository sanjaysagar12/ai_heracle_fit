import 'package:ai_heracle_fit/core/models/user_profile.dart';
import 'package:ai_heracle_fit/core/services/api_client.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();

  Future<UserProfile?> fetchProfile() async {
    try {
      final response = await ApiClient.instance.get('/api/user/profile');

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
}
