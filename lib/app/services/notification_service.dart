import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import '../app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    await FirebaseMessaging.instance.requestPermission();

    final token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onMessage.listen(showNotificationFromRemote);
    FirebaseMessaging.onMessageOpenedApp.listen(showNotificationFromRemote);
  }

  void onNotificationTap(NotificationResponse details) {
    final payload = details.payload;
    if (payload != null) {
      final data = jsonDecode(payload);
      navigatorKey.currentContext?.go(data["route"]);
    }
  }

  void showNotificationFromRemote(RemoteMessage message) {
    String payload = jsonEncode({
      "title": message.notification?.title ?? "New Alert",
      "body": message.notification?.body ?? "Check your notifications",
      "route": "/notifications"
    });
    showNotification(
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      payload: payload,
    );
  }

  Future<void> showNotification(String title, String body,
      {required String payload}) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'High Priority',
      channelDescription: 'For urgent messages',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
