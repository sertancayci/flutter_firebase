import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    notifacationServices.getDeviceToken().then((value) {
      if(kDebugMode) {
        print('Device Token: $value');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              notifacationServices.getDeviceToken().then((value) async {
                var data = {
                  "message":{
                    // "token": value.toString(),
                    "token": "dDpIHPw5SSSQRDgwcOG3HL:APA91bGIXT7mVIsZaOcQH8V45dt8YIk6UkJCi5msfdFymFzYU1vFV5o9u0lP9QtUQGnM9fZfbXklokPHl82qBhEosf6ZqAYsEFsi0pkc6w5Mtx7U2-bed0IU2BjmZwJR-g9x6QDicm8G",
                    "notification":{
                      "body":"This is notification message!",
                      "title":"Message"
                    }
                  },
                  "data": {
                    "type": "msj",
                    "id": "srt1231",
                  },
                };
                await http.post(Uri.parse('https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send'),
                    body: jsonEncode(data),
                    headers: {
                    'Content-Type': 'applicatiom/json; charset=UTF-8',
                      'Authorization': 'Bearer ya29.a0AfB_byAJmBHDyfvu5IaYQS1bPkARVPS5-A_WryJW1fBtY-r2vxku18lq_A3gRUYUR2XBNstK6G09UsSTvKzqOpw5maDEPgJuEfm_VjCu01fnlO_v3kV2PlAGQKWopTPkxTlpFlg7TLyKK_deS_FWhL1nV8Tozm_Zzf4BaCgYKAf8SARASFQGOcNnCUmOnaVYi6pRewVCQTzYG6A0171',
                });
              });
            },
            child: Text('Send Notification')),
      ),
    );
  }
}
