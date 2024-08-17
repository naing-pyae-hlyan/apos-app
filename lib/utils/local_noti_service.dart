import 'dart:math';

import 'package:apos_app/lib_exp.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotiService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notifications.initialize(initializationSettings);
  }

  static Future<void> showOTP({
    required Function(String) generatedOTP,
  }) async {
    final otp = RandomIdGenerator.generateRandomDigits(6);
    final sec = Random().nextInt(10) + 5;
    await Future.delayed(
      Duration(seconds: sec),
      () async {
        await showNotification(
          Consts.appName,
          "$otp is your verification code. For your security, please do not share this.code.",
        );
        generatedOTP(otp);
      },
    );
  }

  static Future<void> showNotification(
    String title,
    String body, {
    int duration = 7000,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'apos_app',
      'notification',
      importance: Importance.max,
      priority: Priority.high,
      timeoutAfter: duration,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _notifications.show(0, title, body, platformChannelSpecifics);
  }
}
