import  'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final String title; 
  const EventDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Event Manager'),
        ),
        body: SafeArea(
          child: Text(title),


        ),
      ), 
    );   
  }
}