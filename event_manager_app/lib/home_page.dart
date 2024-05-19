import 'dart:collection';
import 'dart:ffi';

import 'package:event_manager_app/database_helper.dart';
import 'package:event_manager_app/event_detail_page.dart';
import 'package:event_manager_app/new_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';/*
import 'package:pie_chart/pie_chart.dart';*/
import 'package:fl_chart/fl_chart.dart';
import 'package:path/path.dart' as pathdb;
import 'package:sqflite/sqflite.dart';
class Person {
  String name;
  String lastName;
  DateTime birth;

  Person({
    required this.name,
    required this.lastName,
    required this.birth
  });

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'last_name': lastName,
      'birth': birth.toString(),
    };
  }

  @override
  String toString() {
    return 'Person{name: $name, last_name: $lastName, birth: $birth}';
  }
}

class Event {
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startHour;
  int expectedParticipants;
  int actualParticipants;
  String img;
  List<Person> participants = [];

  Event(
      {required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.startHour,
      required this.expectedParticipants,
      required this.actualParticipants,
      required this.img});

  void setParticipants(List<Person> participants) {
    this.participants = participants;
  }

  Map<String, Object?> toMap() {
    return {'title': title, 'description': description, 'startDate': startDate.toString(), 
            'endDate': endDate.toString(), 'startHour': startHour.toString(), 'expectedParticipants': expectedParticipants, 
            'actualParticipants': actualParticipants, 'img': img};
  }

  @override
  String toString() {
    return 'Event{title: $title, description: $description, startDate: $startDate, endDate: $endDate, startHour: $startHour, expectedParticipants: $expectedParticipants, actualParticipants: $actualParticipants, img: $img}';
  }

}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Event> events_from_db = [];

  TimeOfDay parseTimeOfDay(String time) {
  final format = RegExp(r'^([0-9]{2}):([0-9]{2})$');
  final match = format.firstMatch(time.toString().substring(10, time.toString().length-1));
  print(time.toString());
  if (match != null) {
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);

    return TimeOfDay(hour: hour, minute: minute);
  } else {
    throw FormatException("Invalid time format");
  }
}


  void _fetchEventi() async {
    print("im fetching");
    final db = DatabaseHelper.instance;
    final List<Map<String, dynamic>> maps =
        await db.database.then((db) => db.query('event'));
    final List<Map<String, dynamic>> mapsParticipants =
        await db.database.then((db) => db.query('participant'));

    setState(() {
      events_from_db = List.generate(maps.length, (i) {
        final title = maps[i]['title'];
        final description = maps[i]['description'];
        final startDate = maps[i]['startDate'];
        final endDate = maps[i]['endDate'];
        final startHour = maps[i]['startHour'];
        final expectedParticipants = maps[i]['expectedParticipants'];
        final actualParticipants = maps[i]['actualParticipants'];
        final img = maps[i]['img'];
        final newEvent = Event(
            title: title as String,
            description: description as String,
            startDate: DateTime.parse(startDate),
            endDate: DateTime.parse(endDate),
            startHour: parseTimeOfDay(startHour),
            expectedParticipants: expectedParticipants as int,
            actualParticipants: actualParticipants as int,
            img: img as String,
          );
        List<Person?> participants = List.generate(mapsParticipants.length, (index) {
          if(mapsParticipants[index]['event_title'] == newEvent.title) {
            return Person(name: mapsParticipants[index]['name'], lastName: mapsParticipants[index]['last_name'], birth: DateTime.parse(mapsParticipants[index]['birth']));
          }
          else {
            return null;
          }
        });
        List<Person> participantsNotNull = participants.whereType<Person>().toList();
        newEvent.setParticipants(participantsNotNull);
        return newEvent;
      });
      events = events_from_db;
      filteredEvents = events;
    });
  }

  List<Event> events = [
    Event(
      title: 'Coachella',
      description:
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
      description: 'parade',
      startDate: DateTime(2024, 2, 11, 08, 30),
      endDate: DateTime(2024, 6, 7, 15, 30),
      startHour: TimeOfDay(hour: 22, minute: 30),
      expectedParticipants: 500,
      actualParticipants: 460,
      img: 'assets/cena.png',
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
  ];

  int currentPageIndex = 0;

  final List<bool> isSelectedTogglePastIncomingEvents = [true, false];
  final List<bool> isSelectedThemeFilter = [true, true, true];
  
  List<bool> _isOpen = [];
  List<Event> filteredEvents = [];
 
  _HomePageState() {
    _isOpen = List.generate(events.length, (index) => false);
    //filteredEvents = events;
    _fetchEventi();
    print(filteredEvents);
  }

  void filterEvents(String query) {
    setState(() {
      filteredEvents = events
          .where((ev) => ev.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
  
  List<int> numeroPartecipantiAttivi() {
    List<int> numeri= [0,0];
    int i;
    for(i=0; i<events.length; i++){
      numeri[0] += events[i].actualParticipants;
      numeri[1] += (events[i].expectedParticipants - events[i].actualParticipants);
    }
    return numeri;
  }

  double numLineChart(int mese, String tipo){
    List<double> partecipanti= [0,0];
    int i;
    int ret=0;
    for(i=0; i<events.length; i++){
      if(mese == events[i].startDate.month.toInt() && DateTime.now().year == events[i].startDate.year){
        if(tipo == 'actual'){
          partecipanti[0] += events[i].actualParticipants;
          ret=0;
        }
        else{
          partecipanti[1] += events[i].expectedParticipants;
          ret=1;
        }
      }
    }
    return partecipanti[ret];
  }

  List<FlSpot> lineGenerator(String tipo){
    List<FlSpot> punti = [];
    int i=0;
    for(i=0; i<12; i++){
      punti.add(FlSpot((i + 1).toDouble(), numLineChart(i + 1, tipo)));
    }
    return punti;
  }

  LineChartBarData get lineChartBarDataExpected => LineChartBarData(
        isCurved: true,
        color: Colors.tealAccent.withOpacity(0.7),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        
        spots: lineGenerator('expected')
      );

  LineChartBarData get lineChartBarDataActual => LineChartBarData(
        isCurved: true,
        color: Colors.tealAccent[600],
        barWidth: 5,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: true, color: Colors.red.shade300.withOpacity(0.7)),
        spots: lineGenerator('actual'),
      );
  
  List<LineChartBarData> get linesBarsData => [
    lineChartBarDataActual,
    lineChartBarDataExpected
  ];

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

  void submitAddPerson(setState, eventTitle) {
    if(controller1.text == "" || controller2.text == "" || birthDate == DateTime.now()){
      setState(() {
        invalidPartecipant= "ERROR: In order to add a new partecipant you should have to insert all the fields";      
      });
    }else{
      Person new_participant = Person(
        name: controller1.text,
        lastName: controller2.text,
        birth: birthDate);
      DatabaseHelper.instance.insertParticipant(eventTitle, new_participant);
      Navigator.of(context).pop(new_participant);
      controller1.clear();
      controller2.clear();
      datePrompt = "Select date of birth";
      invalidPartecipant = "";
    }
  }

  Future<Person?> openAddParticipantDialog(eventTitle) => showDialog<Person>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add new participant'),
            content: SingleChildScrollView(
              child: Column(
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
                  Text(invalidPartecipant, 
                    style: TextStyle(
                      color: Colors.red[300], 
                      fontWeight: FontWeight.bold),
                  )
              ],),
            ),
            actions: [
              TextButton(
                clipBehavior: Clip.antiAlias,
                onPressed: () => submitAddPerson(setState, eventTitle),
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
              content: SingleChildScrollView(
                child: Column(
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
              ),
              actions: [
                TextButton(
                  clipBehavior: Clip.antiAlias,
                  onPressed: () {
                    applyFilters(true);
                  },
                  child: Text('FILTER'),
                )
              ],
            );
          },
        ));

Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('J', style: style); 
        break;
      case 2:
        text = const Text('F', style: style);
        break;
      case 3:
        text = const Text('M', style: style);
        break;
      case 4:
        text = const Text('A', style: style); 
        break;
      case 5:
        text = const Text('M', style: style);
        break;
      case 6:
        text = const Text('J', style: style);
        break;
      case 7:
        text = const Text('J', style: style); 
        break;
      case 8:
        text = const Text('A', style: style);
        break;
      case 9:
        text = const Text('S', style: style);
        break;
      case 10:
        text = const Text('O', style: style); 
        break;
      case 11:
        text = const Text('N', style: style);
        break;
      case 12:
        text = const Text('D', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("suresure");
    print(isSelectedTogglePastIncomingEvents.length);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Center(
            child: Text('Thirty Green Events',
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 30, color: Colors.teal.shade900 ),),
          ),
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
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
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
                                    child: Text(ev.description),
                                  ),
                                  ElevatedButton(
                                    child: Text('new participant'),
                                    onPressed: () async {
                                      controller1.clear();
                                      controller2.clear();
                                      datePrompt = "Select date of birth";
                                      invalidPartecipant = "";
                                      final person =
                                          await openAddParticipantDialog(ev.title);
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
                      leading: const Icon(Icons.search_rounded),
                      onChanged: (value) {
                        applyFilters(false);
                      },
                      hintText: "Search by title",
                      controller: searchBarController,
                      
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 7, // Imposta l'elevazione desiderata
                        ),
                        onPressed: () {
                          openApplyFiltersDialog();
                        },
                        child: Text("Filter")),
                      
                    ),
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
                                clipBehavior: Clip.antiAlias,
                                onPressed: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NewEvent(event: ev,)))
                                      .then((newEvent) {
                                    if (newEvent != null) {
                                      if(ev != null){
                                        setState(() {
                                          newEvent.participants = ev.participants;
                                          newEvent.actualParticipants = ev.actualParticipants;
                                          events.remove(ev);
                                          events.add(newEvent);
                                        });
                                      }else{
                                        setState(() {
                                          events.add(newEvent);
                                          _isOpen.add(false);
                                          DatabaseHelper.instance.insertEvento(ev);
                                        });
                                      };
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
                                    return Text( (isExpanded? "Hide Attendees" : "View Attendees" ), 
                                        textAlign: TextAlign.right, 
                                        style: TextStyle(
                                          height: 3.3, /*per allineare il testo alla freccia*/
                                          color: const Color.fromARGB(225, 62,158,135),
                                          fontWeight: FontWeight.bold)  
                                        );
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Here you can find all the statistics about your events!",
                    style: TextStyle(color: Colors.teal[800], 
                                    fontSize: 30, 
                                    fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center,
                    ),
                    Text("Number of events saved", 
                      style: TextStyle(color: Colors.teal, 
                                fontSize: 20, 
                                fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,),
                    Text(events.length.toString(),
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
                    /*PieChart(dataMap: dataActivePart),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 0.0,
                              sectionsSpace: 3.0,
                              sections: [
                                PieChartSectionData(
                                  radius: 80,
                                  value: numeroPartecipantiAttivi()[0].toDouble(), 
                                  title: '${(numeroPartecipantiAttivi()[0] / (numeroPartecipantiAttivi()[0]+numeroPartecipantiAttivi()[1]) * 100).toStringAsFixed(1)}%', 
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.teal.shade800,
                                      Colors.teal.shade300,
                                    ],
                                  ),
                                  ),
                                PieChartSectionData(
                                  radius: 70,
                                  value: numeroPartecipantiAttivi()[1].toDouble(), 

                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.tealAccent.shade700,
                                      Colors.tealAccent.shade100,
                                    ],
                                  ),
                                  title: '${(numeroPartecipantiAttivi()[1] / (numeroPartecipantiAttivi()[0]+numeroPartecipantiAttivi()[1]) * 100).toStringAsFixed(1)}%'),],
                            ),
                            
                          ),
                        ),
                        Column(
                          children: [
                            Icon(Icons.person_2_rounded, color: Colors.tealAccent ),
                            Text('absent',
                             style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.tealAccent,
                                decorationThickness: 3)
                              ),
                            Icon(Icons.person_2_rounded, color: Colors.tealAccent.shade700 ),
                            Text('active', 
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.tealAccent.shade700,
                                decorationThickness: 3)
                              ),
                          ],
                        )
                      ],
                    ),     
                    Divider(color: Colors.teal.shade100,
                            thickness: 2.0,),
                    Text("Temporal distribution of partecipants during the year", 
                      style: TextStyle(color: Colors.teal, 
                                fontSize: 20, 
                                fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: LineChart(
                                    LineChartData(
                                      lineTouchData: LineTouchData(
                                        enabled: true,
                                        touchTooltipData: LineTouchTooltipData(    
                                          tooltipRoundedRadius: 20.0,
                                          fitInsideHorizontally: true,
                                          fitInsideVertically: true,
                                        )
                                      ),
                                      borderData: FlBorderData(show: false), 
                                      lineBarsData: linesBarsData,
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 32,
                                            interval: 1,
                                            getTitlesWidget: bottomTitleWidgets,
                                            
                                          ),
                                        ),
                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),

                                        ),
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        )
                                    ),
                                    
                                  ),
                        ),
                        Column(
                          children: [
                            Icon(Icons.person_2_rounded, color: Colors.tealAccent ),
                            Text('expected',
                             style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.tealAccent,
                                decorationThickness: 3)
                              ),
                            Icon(Icons.person_2_rounded, color: Colors.tealAccent.shade700 ),
                            Text('real',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.tealAccent.shade700,
                                decorationThickness: 3)
                              ),
                          ],
                        )
                      ],
                    )],
                  
                  ),
            )]
            ),
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
                  DatabaseHelper.instance.insertEvento(newEvent);
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
