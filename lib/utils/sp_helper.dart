import 'package:shared_preferences/shared_preferences.dart';

const _usernameKey = 'username';
const _passwordKey = 'password';

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
    required String username,
    required String password,
  }) async {
    await setString(_usernameKey, username);
    await setString(_passwordKey, password);
  }

  static Future<String> get username async {
    return await getString(_usernameKey) ?? "";
  }

  static Future<String> get password async {
    return await getString(_passwordKey) ?? "";
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
