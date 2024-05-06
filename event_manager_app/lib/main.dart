import 'package:event_manager_app/ListTileExample.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Event {
  String title;
  String desctiption;

  Event({
    required this.title,
    required this.desctiption,
  });
}

List<Event> events = [
  Event(
    title: 'Coachella',
    desctiption: 'concert',
  ),
  Event(
    title: 'Milano Fashon Week',
    desctiption: 'parade',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              Event ev = events[index];
              return ListTile(
                  title: Text(ev.title), 
                  subtitle: Text(ev.desctiption)
              );
            }
          )
        ),
      ),
    );
  }
}
