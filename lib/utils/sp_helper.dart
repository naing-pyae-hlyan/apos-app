import 'package:shared_preferences/shared_preferences.dart';

const _emailKey = 'email';
const _passwordKey = 'password';
const _fcmTokenKey = "fcm_token";

class SpHelper {
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<void> rememberMe({
    required String email,
    required String password,
  }) async {
    await setString(_emailKey, email);
    await setString(_passwordKey, password);
  }

  static Future<void> setFcmToken(String? fcmToken) async {
    if (fcmToken != null) {
      await setString(_fcmTokenKey, fcmToken);
    }
  }

  static Future<String?> get fcmToken async {
    return await getString(_fcmTokenKey);
  }

  static Future<String> get username async {
    return await getString(_emailKey) ?? "";
  }

  static Future<String> get password async {
    return await getString(_passwordKey) ?? "";
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
