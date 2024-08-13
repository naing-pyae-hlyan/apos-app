import 'package:apos_app/lib_exp.dart';

class FMUtils {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static FirebaseMessaging get messaging => _messaging;

  static Future<String?> get token async {
    String? token = await _messaging.getToken();
    return token;
  }
}
