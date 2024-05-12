import 'package:event_manager_app/event_detail_page.dart';
import 'package:event_manager_app/new_event.dart';
import  'package:flutter/material.dart';

class Event {
  String title;
  String desctiption;
  bool completed;
  DateTime date;
  int expectedParticipants;
  int actualParticipants;
  /*File img;*/
  

  Event({
    required this.title,
    required this.desctiption,
    required this.completed,
    required this.date,
    required this.expectedParticipants,
    required this.actualParticipants,
    /*required this.img,*/
  });
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> events = [
    Event(
      title: 'Coachella',
      desctiption: 'Il Coachella Valley Music and Arts Festival, comunemente conosciuto come Coachella, è uno dei festival musicali più celebri al mondo. Si tiene annualmente nella Valle di Coachella, nella contea di Riverside, in California, vicino alla città di Indio. Fondato nel 1999 da Paul Tollett e organizzato dalla società di promozione Goldenvoice, il Coachella Festival è diventato un\'icona della cultura musicale e dei festival.',
      completed: false,
      date: DateTime(2024, 5, 7, 15, 30),
      expectedParticipants: 300,
      actualParticipants:  200,
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Milano Fashon Week',
      desctiption: 'parade',
      completed: false,
      date: DateTime(2024, 2, 10, 08, 30),
      expectedParticipants: 5000,
      actualParticipants: 4600,
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.tealAccent[700],
          title: Text('Event Manager'),
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final eventsIndex = index;
              Event ev = events[eventsIndex];
              return Card(
                child: Column(
                  children: [
                    /*Image.file(
                      ev.img
                    ),*/
                    ListTile(
                      title: Text(
                        ev.title,
                      ), 
                      subtitle:  Text(ev.desctiption + ev.date.toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EventDetailPage(event: ev))
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewEvent())
            ).then((newEvent) {
                  print("coco");
                  print(newEvent);
                  if(newEvent != null) {
                    setState((){
                      events.add(newEvent);
                    });
                  }
              });
          },
          child: const Icon(Icons.add),
        ),
      );
  }
}