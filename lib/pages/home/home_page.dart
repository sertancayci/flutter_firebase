import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firebase_api.dart';
import 'package:http/http.dart' as http;

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
    notifacationServices.initPushNotifications(context);
    notifacationServices.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              notifacationServices.getDeviceToken().then((value) async {
                var data = {
                  "to": value,
                  "notification": {
                    "title": "Flutter Firebase",
                    "body": "Flutter Firebase Cloud Messaging",
                    "mutable_content": true,
                    "sound": "Tri-tone"
                  },
                  "data": {
                    "type": "msj",
                    "id": "1",
                  }
                };
                await http.post(Uri.parse(uri),
                    body: jsonEncode(data),
                    headers: {
                    'Content-Type': 'applicatiom/json; charset=UTF-8',
                      'Authorization': 'key=$serverToken',
                });
              });
            },
            child: Text('Send Notification')),
      ),
    );
  }
}
