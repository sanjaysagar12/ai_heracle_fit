import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_heracle_fit/core/services/api_client.dart';

class AuthService {
  static const _jwtKey = 'backend_jwt';

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Main sign-in flow ──────────────────────────────────────────────────────

  /// Returns the backend JWT on success, null if cancelled / error.
  Future<String?> signInWithGoogle() async {
    try {
      // 1. Trigger Google account picker
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('[Auth] Sign-in cancelled by user.');
        return null;
      }

      // 2. Get raw Google tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print(
        '[Auth] Raw Google ID token (NOT sent to backend): ${googleAuth.idToken}',
      );

      // 3. Exchange with Firebase → creates a Firebase session
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;

      // 4. Get Firebase ID token  ← this is what the backend expects
      //    iss: https://securetoken.google.com/<project-id>
      final String firebaseIdToken = await firebaseUser.getIdToken() ?? '';

      print('==============================');
      print('[Auth] Firebase ID Token (sent to backend):');
      print(firebaseIdToken);
      print('==============================');
      print('[Auth] Signed in as: ${firebaseUser.displayName}');
      print('[Auth] Email: ${firebaseUser.email}');

      // 5. POST Firebase ID token to backend
      final backendJwt = await _exchangeTokenWithBackend(firebaseIdToken);
      if (backendJwt == null) return null;

      // 6. Persist the backend JWT for future API calls
      await _saveJwt(backendJwt);

      return backendJwt;
    } catch (e, st) {
      print('[Auth] Error during Google Sign-In: $e\n$st');
      return null;
    }
  }

  // ── Backend exchange ───────────────────────────────────────────────────────

  Future<String?> _exchangeTokenWithBackend(String firebaseIdToken) async {
    // postUnauthenticated handles errors internally, returns null on failure.
    final body = await ApiClient.instance.postUnauthenticated(
      '/auth/google/token',
      data: {'idToken': firebaseIdToken},
    );

    if (body == null) {
      print('[Auth] Backend call failed.');
      return null;
    }

    final jwt = body['token'] as String?;
    if (jwt != null) {
      print('[Auth] Backend JWT received.');
    } else {
      print('[Auth] Backend response missing "token" field: $body');
    }
    return jwt;
  }

  // ── JWT persistence ────────────────────────────────────────────────────────

  Future<void> _saveJwt(String jwt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtKey, jwt);
    print('[Auth] Backend JWT saved to SharedPreferences.');
  }

  /// Call this anywhere to get the stored backend JWT for API requests.
  Future<String?> getStoredJwt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jwtKey);
  }

  // ── Sign out ───────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jwtKey);
    print('[Auth] User signed out and JWT cleared.');
  }
}
