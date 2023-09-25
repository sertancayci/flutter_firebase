import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_firebase/pages/notification_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void handleMessages(BuildContext context, RemoteMessage message) {
    // if (message == null) return;

    if (message.data["type"] == 'msj') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationScreen(
                    id: message.data['id'],
                  )));
    }
    // navigatorKey.currentState?.pushNamed(
    //   NotificationScreen.route,
    //   arguments: message,
    // );
  }

  initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notification) async {
      handleMessages(context, message);
      // handleMessages(message);
      // if (notification != null) {
      //   navigatorKey.currentState?.pushNamed(
      //     NotificationScreen.route,
      //     arguments: notification,
      //   );
      // }
    });
  }

  Future<void> initNotifications() async {
    await requestNotificationPermissions();
    final fCMToken = await getDeviceToken();
    // final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');
  }

  Future<void> initPushNotifications(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print(message.data.toString());
      print(message.data['type']);
      print(message.data['id']);

      initLocalNotification(context, message);
      showNotification(message);
    });

    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // FirebaseMessaging.instance.getInitialMessage().then(handleMessages);
    // FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  //showNotification function
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(), channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      sound: channel.sound,
      icon: "@mipmap/ic_launcher",
      //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
      //  icon: largeIconPath
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

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<void> setupInteractMessage(BuildContext context)async{

    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessages(context, initialMessage);
    }


    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessages(context, event);
    });

  }

  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
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

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // print('Message notification title: ${message.notification?.title}');
    // print('Message notification body: ${message.notification?.body}');
    // print('Message data: ${message.data}');
  }
}
