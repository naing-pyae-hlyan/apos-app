import 'package:apos_app/lib_exp.dart';

class FCMUtils {
  static Future<bool> checkNotificationPermission() async {
    try {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();

      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> requestNotiPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        sound: true,
        badge: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (_) {
      return false;
    }
  }
}
