import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Event {
  String title;
  String desctiption;
  bool completed;
  DateTime date;

  Event({
    required this.title,
    required this.desctiption,
    required this.completed,
    required this.date,
  });
}

List<Event> events = [
  Event(
    title: 'Coachella',
    desctiption: 'concert',
    completed: false,
    date: DateTime(2024, 5, 7, 15, 30),
  ),
  Event(
    title: 'Milano Fashon Week',
    desctiption: 'parade',
    completed: false,
    date: DateTime(2024, 2, 10, 08, 30),
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
            itemCount: events.length*2-1,
            itemBuilder: (context, index) {
              if (index.isOdd) 
                return Divider();
              final eventsIndex = index ~/2;
              Event ev = events[eventsIndex];
              return ListTile(
                  title: Text(
                    ev.title,
                    style: TextStyle(background: Paint()..color = Colors.cyan)
                  ), 
                  subtitle:  Text(ev.desctiption)

              );
            }
          )
        ),
      ),
    );
  }
}
