import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_firebase/pages/notification_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void handleMessages(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments: message,
    );
  }

  initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notification) async {
      if (notification != null) {
        navigatorKey.currentState?.pushNamed(
          NotificationScreen.route,
          arguments: notification,
        );
      }
    });
  }

  //showNotification function
  Future<void> showNotification(
      RemoteMessage message) async {

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'high important notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
         AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'test ticker',


    );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero,() {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      showNotification(message);
    });



    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessages);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  //getDeviceToken function
  Future<String?> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token!;
  }

  //refreshToken function
  Future<void> refreshToken() async {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
      print('Token refreshed: $event');
    });
  }

  Future<void> initNotifications() async {
    await requestNotificationPermissions();
    final fCMToken = await getDeviceToken();
    // final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');
    initPushNotifications();
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // print('Message notification title: ${message.notification?.title}');
    // print('Message notification body: ${message.notification?.body}');
    // print('Message data: ${message.data}');
  }
}
