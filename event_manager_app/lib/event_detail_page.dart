import 'package:event_manager_app/home_page.dart';
import  'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final Event event; 
  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text('Event Manager'),
        ),
        body: SafeArea(
          child: Text(event.title),
        ),
      );
  }
}