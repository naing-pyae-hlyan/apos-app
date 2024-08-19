import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const _emailKey = 'email';
const _passwordKey = 'password';
const _fcmTokenKey = "fcm_token";
const _favItemsKey = "fav-items";

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

  static Future<void> setEmail(String newEmail) async {
    await setString(_emailKey, newEmail);
  }

  static Future<void> setPassword(String newPassword) async {
    await setString(_passwordKey, newPassword);
  }

  static Future<void> setFcmToken(String? fcmToken) async {
    if (fcmToken != null) {
      await setString(_fcmTokenKey, fcmToken);
    }
  }

  static Future<void> setFavItems(Map<String, List<String>> map) async {
    await setString(_favItemsKey, jsonEncode(map));
  }

  static Future<bool> itemIsFav(String? categoryId, String? productId) async {
    if (categoryId == null || productId == null) return false;
    final result = await favItems;
    if (result[categoryId] == null) return false;
    try {
      final result2 = result[categoryId]!.where((String id) => id == productId);
      return result2.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, List<String>>> get favItems async {
    final result = await getString(_favItemsKey);
    if (result != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(result);
        // Cast the map to Map<String,List<Stirng>>
        final Map<String, List<String>> typedResult = decoded
            .map((key, value) => MapEntry(key, List<String>.from(value)));
        return typedResult;
      } catch (_) {
        return {};
      }
    }
    return {};
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
