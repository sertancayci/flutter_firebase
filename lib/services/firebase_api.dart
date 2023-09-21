import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_firebase/pages/notification_screen.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessages(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessages);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');
    initPushNotifications();
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // print('Message notification title: ${message.notification?.title}');
    // print('Message notification body: ${message.notification?.body}');
    // print('Message data: ${message.data}');
  }
}
