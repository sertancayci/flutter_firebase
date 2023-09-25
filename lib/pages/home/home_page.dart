

import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firebase_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseApi notifacationServices = FirebaseApi();

  @override
  void initState() {
    super.initState();
    notifacationServices.refreshToken();
    notifacationServices.requestNotificationPermissions();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Home Page1')),
    );
  }
}
