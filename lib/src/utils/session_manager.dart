
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) {
      return true;
    }
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      // If there's an error decoding the token (e.g., malformed), consider it expired.
      return true;
    }
  }
}
