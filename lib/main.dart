import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/pages/home/home_page.dart';
import 'package:flutter_firebase/pages/notification_screen.dart';
import 'package:flutter_firebase/services/firebase_api.dart';

import 'services/firebase_analytics.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        AnalyticsService.analyticsObserver,
      ],
      title: "Flutter Firebase",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      home: const HomePage(),
      routes: {
        // HomePage.route: (context) => const HomePage(title: 'Flutter Demo Home Page'),
        NotificationScreen.route: (context) => const NotificationScreen(),
      },
    );
  }
}

