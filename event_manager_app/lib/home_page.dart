import 'package:event_manager_app/event_detail_page.dart';
import 'package:event_manager_app/new_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';/*
import 'package:fl_chart/fl_chart.dart';*/
class Person {
  String name;
  String lastName;
  DateTime birth;

  Person({
    required this.name,
    required this.lastName,
    required this.birth
  });
}

class Event {
  String title;
  String desctiption;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startHour;
  int expectedParticipants;
  int actualParticipants;
  String img;
  List<Person> participants = [];

  Event(
      {required this.title,
      required this.desctiption,
      required this.startDate,
      required this.endDate,
      required this.startHour,
      required this.expectedParticipants,
      required this.actualParticipants,
      required this.img});
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
      desctiption:
          'Il Coachella Valley Music and Arts Festival, comunemente conosciuto come Coachella, è uno dei festival musicali più celebri al mondo. Si tiene annualmente nella Valle di Coachella, nella contea di Riverside, in California, vicino alla città di Indio. Fondato nel 1999 da Paul Tollett e organizzato dalla società di promozione Goldenvoice, il Coachella Festival è diventato un\'icona della cultura musicale e dei festival.',
      startDate: DateTime(2024, 5, 7, 15, 30),
      endDate: DateTime(2024, 6, 7, 15, 30),
      startHour: TimeOfDay(hour: 12, minute: 00),
      expectedParticipants: 300,
      actualParticipants: 200,
      img: 'assets/romantico.jpg',
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Milano Fashon Week',
      desctiption: 'parade',
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

  final List<bool> isSelectedTogglePastIncomingEvents = [true, false];
  final List<bool> isSelectedThemeFilter = [true, true, true];

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

  void applyFilters(close) {
    filterEvents(searchBarController.text);
    setState(() {
      if(!isSelectedThemeFilter[0] && !isSelectedThemeFilter[1] && !isSelectedThemeFilter[2]) {
        filteredEvents = [];
      }
      if(!isSelectedThemeFilter[0] && !isSelectedThemeFilter[1] && isSelectedThemeFilter[2]) {
        filteredEvents = filteredEvents
          .where((element) => element.img == 'assets/romantico.jpg')
          .toList();
      }
      if(!isSelectedThemeFilter[0] && isSelectedThemeFilter[1] && !isSelectedThemeFilter[2]) {
        filteredEvents = filteredEvents
          .where((element) => element.img == 'assets/cena.png')
          .toList();
      }
      if(!isSelectedThemeFilter[0] && isSelectedThemeFilter[1] && isSelectedThemeFilter[2]) {
        filteredEvents = filteredEvents
          .where((element) => element.img == 'assets/cena.png' || element.img == 'assets/romantico.jpg')
          .toList();
      }
      if(isSelectedThemeFilter[0] && !isSelectedThemeFilter[1] && !isSelectedThemeFilter[2]) {
        filteredEvents = filteredEvents
          .where((element) => element.img == 'assets/lavoro.jpg')
          .toList();
      }
      if(isSelectedThemeFilter[0] && !isSelectedThemeFilter[1] && isSelectedThemeFilter[2]) {
        filteredEvents = filteredEvents
          .where((element) => element.img == 'assets/lavoro.jpg' || element.img == 'assets/romantico.jpg')
          .toList();
      }
      if(isSelectedThemeFilter[0] && isSelectedThemeFilter[1] && !isSelectedThemeFilter[2]) {
        filteredEvents = filteredEvents
          .where((element) => element.img == 'assets/cena.png' || element.img == 'assets/lavoro.jpg')
          .toList();
      }
      if(isSelectedThemeFilter[0] && isSelectedThemeFilter[1] && isSelectedThemeFilter[2]) {
        filteredEvents = filteredEvents;
      }
    });
    if(close) {
      Navigator.of(context).pop();
    }
  }

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  Map<String, double> dataActivePart = { /*dat per il diagramma a torta delle statistiche */
    "active": 5,
    "expected": 3,
  };
  final TextEditingController searchBarController = TextEditingController();

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  DateTime birthDate = DateTime.now();
  String datePrompt = "Select date of birth*";
  String invalidPartecipant = "";

  Future<void> _selectDates(BuildContext context, setState) async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      firstDate: DateTime(1900, 1, 1), 
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthDate = picked;
        datePrompt = "Selected:" + DateFormat("yMd").format(birthDate);
      });
    }
  }

  Future<Person?> openAddParticipantDialog() => showDialog<Person>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add new participant'),
            content: Column(
              children: [
                TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Name*',
                      suffixText: 'required',
                    ),
                    controller: controller1,
                ),
                TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Surname*',
                      suffixText: 'required'
                    ),
                    controller: controller2,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(datePrompt),
                      ElevatedButton(
                        onPressed: () => _selectDates(context, setState),
                        child: Icon(Icons.date_range_outlined),
                      ),
                  ],),  
                ),
                Text(invalidPartecipant, style: TextStyle(color: Colors.red[300]),),
            ],),
            actions: [
              TextButton(
                onPressed: () => submitAddPerson(setState),
                child: Text('ADD'),
              ),
            ],
            
          );
        }
      );
    }
  );
  Future<Person?> openApplyFiltersDialog() => showDialog<Person>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Decide which filters to apply'),
              content: Column(
                children: [
                  Text("Filter by theme:"),
                  ToggleButtons(
                    fillColor: Colors.teal,
                    isSelected: isSelectedThemeFilter,
                    onPressed: (int index) {
                      setState(() {
                        isSelectedThemeFilter[index] = !isSelectedThemeFilter[index];
                      });
                    },
                    children: const <Widget>[
                      CircleAvatar(backgroundImage: AssetImage("assets/lavoro.jpg"), radius: 40),
                      CircleAvatar(backgroundImage: AssetImage("assets/cena.png"), radius: 40),
                      CircleAvatar(backgroundImage: AssetImage("assets/romantico.jpg"), radius: 40),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    applyFilters(true);
                  },
                  child: Text('FILTER'),
                )
              ],
            );
          },
        ));
  void submitAddPerson(setState) {
    if(controller1.text == "" || controller2.text == "" || birthDate == DateTime.now()){
      setState(() {
        invalidPartecipant= "ERROR: In order to add a new partecipant you should have to insert all the fields";      
      });
    }else{
      Navigator.of(context).pop(Person(
        name: controller1.text,
        lastName: controller2.text,
        birth: birthDate));
      controller1.clear();
      controller2.clear();
      datePrompt = "Select date of birth";
      invalidPartecipant = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    print("suresure");
    print(isSelectedTogglePastIncomingEvents.length);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Event Manager'),
        ),
        body: <Widget>[
          SafeArea(
              child: Column(
            children: [
              ToggleButtons(
                isSelected: isSelectedTogglePastIncomingEvents,
                onPressed: (index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelectedTogglePastIncomingEvents.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelectedTogglePastIncomingEvents[buttonIndex] = true;
                      } else {
                        isSelectedTogglePastIncomingEvents[buttonIndex] = false;
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
                      if (isSelectedTogglePastIncomingEvents[0] &&
                              ev.endDate.compareTo(DateTime.now()) < 0 ||
                          isSelectedTogglePastIncomingEvents[1] &&
                              ev.endDate.compareTo(DateTime.now()) >= 0) {
                        return InkWell(
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child:
                                        Image.asset(ev.img, fit: BoxFit.cover),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    ev.title,
                                  ),
                                  subtitle: Text(
                                      "From ${DateFormat('EEE, MMM d, yyyy').format(ev.startDate)} at ${DateFormat('h:mm a').format(DateTime(1, 1, 1, ev.startHour.hour, ev.startHour.minute))}\nTo ${DateFormat('EEE, MMM d, yyyy').format(ev.endDate)}\nParticipants ${ev.actualParticipants} of ${ev.expectedParticipants}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(ev.desctiption),
                                ),
                                ElevatedButton(
                                  child: Text('new participant'),
                                  onPressed: () async {
                                    controller1.clear();
                                    controller2.clear();
                                    datePrompt = "Select date of birth";
                                    invalidPartecipant = "";
                                    final person =
                                        await openAddParticipantDialog();
                                    if (person == null) return;
                                    setState(
                                      () {
                                        ev.actualParticipants++;
                                        ev.participants.add(person);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailPage(event: ev)));
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
              ),
            ],
          )),
          //menagment page
          SafeArea(
              child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      onChanged: (value) {
                        applyFilters(false);
                      },
                      hintText: "Search by title",
                      controller: searchBarController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          openApplyFiltersDialog();
                        },
                        child: Text("Filters")),
                  )
                ],
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
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(ev.img),
                                        radius: 60,
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          ev.title,
                                        ),
                                        subtitle: Text(
                                            "From ${DateFormat('EEE, MMM d, yyyy').format(ev.startDate)} at ${DateFormat('h:mm a').format(DateTime(1, 1, 1, ev.startHour.hour, ev.startHour.minute))}\nTo ${DateFormat('EEE, MMM d, yyyy').format(ev.endDate)}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NewEvent()))
                                      .then((newEvent) {
                                    if (newEvent != null) {
                                      setState(() {
                                        events.add(newEvent);
                                        _isOpen.add(false);
                                      });
                                    }
                                  });
                              },
                              child: Text('Modify event information',
                                        style: TextStyle(color: Colors.red[300],
                                                        decoration: TextDecoration.underline,
                                                        decorationColor: Colors.red)
                                     ),
                              
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
                                            child: Text(ev.participants[index].name + " " + ev.participants[index].lastName + " " + "${DateFormat('yMd').format(ev.participants[index].birth)}"),
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
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailPage(event: ev)));
                        },
                      );
                    }),
              ),
            ],
          )),
          SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Here you can find all the statistics about your events!",
                  style: TextStyle(color: Colors.teal[900], 
                                  fontSize: 30, 
                                  fontWeight: FontWeight.bold,),
                  textAlign: TextAlign.center,
                  ),
                  Text("Number of events saved", 
                    style: TextStyle(color: Colors.teal, 
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center,),
                  Text("22",
                      style: TextStyle(color: Colors.teal[400], 
                                  fontSize: 50, 
                                  fontWeight: FontWeight.bold,),
                        textAlign: TextAlign.center,),
                  Divider(color: Colors.teal.shade100,
                          thickness: 2.0,),
                  Text("Percentage of active participation in events", 
                    style: TextStyle(color: Colors.teal, 
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center,),
                  PieChart(dataMap: dataActivePart),
                  /*PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: 40, color: Colors.blue, title: 'A'),
                        PieChartSectionData(value: 30, color: Colors.red, title: 'B'),
                        PieChartSectionData(value: 20, color: Colors.green, title: 'C'),
                        PieChartSectionData(value: 10, color: Colors.yellow, title: 'D'),],
                    ),
                    swapAnimationDuration: Duration(milliseconds: 150), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ),  */   
                  Divider(color: Colors.teal.shade100,
                          thickness: 2.0,),
                  Text("Temporal distribution of events", 
                    style: TextStyle(color: Colors.teal, 
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center,),
                ],
                ),
          )]
          )
        ),


        ][currentPageIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewEvent()))
                .then((newEvent) {
              print(newEvent);
              if (newEvent != null) {
                setState(() {
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
              icon: Icon(Icons.manage_accounts_rounded),
              label: 'Manage',
            ),
            NavigationDestination(
              icon: Icon(Icons.ssid_chart_rounded),
              label: 'Statistics',
            ),
          ],
        ));
  }
}
