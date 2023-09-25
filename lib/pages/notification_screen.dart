

import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final String id ;
  const NotificationScreen({Key? key , required this.id}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Message Screen' +widget.id)  ,
      ),
    );
  }
}