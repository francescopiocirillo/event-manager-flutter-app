import 'package:event_manager_app/event_detail_page.dart';
import 'package:event_manager_app/new_event.dart';
import 'package:flutter/cupertino.dart';
import  'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Person {
  String name;
  String lastName;
  int age;

  Person({
    required this.name,
    required this.lastName,
    required this.age
  });
}

class Event {
  String title;
  String desctiption;
  bool completed;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startHour;
  int expectedParticipants;
  int actualParticipants;
  String img;
  List<Person> participants = [];

  Event({
    required this.title,
    required this.desctiption,
    required this.completed,
    required this.startDate,
    required this.endDate,
    required this.startHour,
    required this.expectedParticipants,
    required this.actualParticipants,
    required this.img
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
      startDate: DateTime(2024, 5, 7, 15, 30),
      endDate: DateTime(2024, 6, 7, 15, 30),
      startHour: TimeOfDay(hour: 12, minute: 00),
      expectedParticipants: 300,
      actualParticipants:  200,
      img: 'assets/romantico.jpg',
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Milano Fashon Week',
      desctiption: 'parade',
      completed: false,
      startDate: DateTime(2024, 2, 11, 08, 30),
      endDate: DateTime(2024, 6, 7, 15, 30),
      startHour: TimeOfDay(hour: 22, minute: 30),
      expectedParticipants: 5000,
      actualParticipants: 4600,
      img: 'assets/cena.png',
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
  ];

  int currentPageIndex = 0;

  final List<bool> isSelected = [true, false];
  
  List<bool> _isOpen = [];

  _HomePageState() {
    _isOpen = List.generate(events.length, (index) => false);
    filteredEvents = events;
  }
  
  List<Event> filteredEvents = [];

  void filterEvents(String query) {
    setState(() {
      filteredEvents = events
          .where((ev) => ev.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  Future<Person?> openDialog() => showDialog<Person>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add new participant'),
      content: Column(
        children: [
          TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText:'Name*'
              ),
              controller: controller1,
          ),
          TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText:'Cognome*'
              ),
              controller: controller2,
          ),
          TextField(
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                hintText:'Age*'
              ),
              controller: controller3,
          ),
      ],) ,
      
      actions: [
        TextButton(
          onPressed: submitAddPerson,
          child: Text('ADD'),
        )
      ],)
  );

  void submitAddPerson() {
    Navigator.of(context).pop(Person(name: controller1.text, lastName: controller2.text, age: int.parse(controller3.text)));
    controller1.clear();
    controller2.clear();
    controller3.clear();
  }

  @override
  Widget build(BuildContext context) {
    print("suresure");
    print(isSelected.length);
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.teal,
          title: Text('Event Manager'),
        ),
        body: <Widget>[
          SafeArea(
          child: Column(
            children: [
              ToggleButtons(
                isSelected: isSelected,
                onPressed: (index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Past events"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Incoming events"),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final eventsIndex = index;
                    Event ev = events[eventsIndex];
                    if(isSelected[0] && ev.endDate.compareTo(DateTime.now()) < 0 || isSelected[1] && ev.endDate.compareTo(DateTime.now()) >= 0) {
                      return InkWell(
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: Image.asset(
                                    ev.img,
                                    fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  ev.title,
                                ),
                                subtitle:  Text("From ${DateFormat('EEE, MMM d, yyyy').format(ev.startDate)} at ${DateFormat('h:mm a').format(DateTime(1, 1, 1, ev.startHour.hour, ev.startHour.minute))}\nTo ${DateFormat('EEE, MMM d, yyyy').format(ev.endDate)}\nParticipants ${ev.actualParticipants} of ${ev.expectedParticipants}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(ev.desctiption),
                              ),
                              ElevatedButton(
                                child: Text('new participant'),
                                onPressed: () async {
                                    final person = await openDialog();
                                    if(person == null) return;
                                    setState(() {
                                      ev.actualParticipants++;
                                      ev.participants.add(person);
                                    },);
                                }, 
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EventDetailPage(event: ev))
                            );
                          },
                      );
                    }
                    else {
                      return SizedBox.shrink();
                    }
                  }
                ),
              ),
            ],
          )
        ),
        //menagment page
        SafeArea(
          child: Column(
            children: [
              SearchBar(
                onChanged: filterEvents,
                hintText: "Search by title",
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final eventsIndex = index;
                    Event ev = filteredEvents[eventsIndex];
                    return InkWell(
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle),
                                      child: CircleAvatar(backgroundImage: AssetImage(ev.img), radius: 60,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        ev.title,
                                      ),
                                      subtitle: Text("From ${DateFormat('EEE, MMM d, yyyy').format(ev.startDate)} at ${DateFormat('h:mm a').format(DateTime(1, 1, 1, ev.startHour.hour, ev.startHour.minute))}\nTo ${DateFormat('EEE, MMM d, yyyy').format(ev.endDate)}"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NewEvent())
                                ).then((newEvent) {
                                      if(newEvent != null) {
                                        setState((){
                                          events.add(newEvent);
                                          _isOpen.add(false);
                                        });
                                      }
                                  });
                              },
                              child: Text('Modify event information'),
                            ),
                            ExpansionPanelList(
                              animationDuration:
                                Duration(milliseconds: 1000),
                              expandedHeaderPadding:
                                EdgeInsets.all(8),
                              children: [
                                ExpansionPanel(
                                  headerBuilder: (context, isExpanded) {
                                    return Text("Hello");
                                  }, 
                                  canTapOnHeader: true,
                                  body: SizedBox(
                                      height: 100,
                                      child: ListView.builder(itemCount: ev.participants.length, itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: SingleChildScrollView(child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(ev.participants[index].name),
                                          )),
                                        );
                                      },),
                                    ),
                                  isExpanded: _isOpen[index],
                                ),
                              ],
                              expansionCallback: (i, isOpen) =>
                                setState(() =>
                                  _isOpen[index] = !_isOpen[index]
                                )
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EventDetailPage(event: ev))
                          );
                        },
                    );
                  }
                ),
              ),
              
            ],
          )
        ),
        Text("Pippo"),
        ][currentPageIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewEvent())
            ).then((newEvent) {
                  print(newEvent);
                  if(newEvent != null) {
                    setState((){
                      events.add(newEvent);
                      _isOpen.add(false);
                    });
                  }
              });
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.teal,
            onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_rounded),
            label: 'Menage',
          ),
          NavigationDestination(
            icon: Icon(Icons.ssid_chart_rounded),
            label: 'Statistics',
          ),
        ],)
      );
  }
}