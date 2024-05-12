import 'package:event_manager_app/event_detail_page.dart';
import 'package:event_manager_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({super.key});

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final textNomeController = TextEditingController();
  final textDescrizioneController = TextEditingController();
  String datePrompt = "Select dates of the event";
  String timePrompt = "Select event's beginning hour";
  int _selectedImage = 0;
  DateTimeRange selectedDates = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 12, minute: 00);
  double expectedParticipants = 12;

  Future<void> _selectDates(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context, 
      firstDate: DateTime(2024, 1, 1), 
      lastDate: DateTime(2030, 12, 31),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        datePrompt = "Selected date:\n" + DateFormat("EEE, MMM d, yyyy").format(startDate)+" / "+
          DateFormat("EEE, MMM d, yyyy").format(endDate) ;
      });
    }
  }

  Future<void> selectedTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: const TimeOfDay(minute: 00, hour: 00)
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
        timePrompt = "Selected hour: " + 
          DateFormat('h:mm a').format(DateTime(1,1,1,startTime.hour,startTime.minute));
      });
    }
  }

  @override
  void dispose() {
    textNomeController.dispose();
    textDescrizioneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Event Manager'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Choose your event's theme!"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 3, color: _selectedImage == 0 ? Colors.red:Colors.transparent), shape: BoxShape.circle),
                      child: CircleAvatar(backgroundImage: AssetImage("assets/lavoro.jpg"), radius: 60,),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 3, color: _selectedImage == 1 ? Colors.red:Colors.transparent), shape: BoxShape.circle),
                      child: CircleAvatar(backgroundImage: AssetImage("assets/cena.png"), radius: 60,),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = 2;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 3, color: _selectedImage == 2 ? Colors.red:Colors.transparent), shape: BoxShape.circle),
                      child: CircleAvatar(backgroundImage: AssetImage("assets/romantico.jpg"), radius: 60,),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: textNomeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Inserire il nome dell\'evento',
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: textDescrizioneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Inserire la descrizione dell\'evento',
                ),
                maxLines: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("Insert number of expected participants"),
            ),
            Slider(
              value: expectedParticipants,
              min: 0,
              max: 500,
              divisions: 500,
              label: expectedParticipants.toStringAsFixed(0),
              onChanged: (newValue) {
                setState(() {
                  expectedParticipants = newValue;
                });
              },
            ),
            ElevatedButton(
              onPressed: () => _selectDates(context),
              child: Text(datePrompt),
            ),
            ElevatedButton(
              onPressed: () => selectedTime(context),
              child: Text(timePrompt),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, Event(title: textNomeController.text, desctiption: textDescrizioneController.text, 
          completed: false, startDate: startDate, endDate: endDate, startHour: startTime, expectedParticipants: expectedParticipants.toInt(), actualParticipants: 0, img: _selectedImage == 0 ? "assets/lavoro.jpg" : (_selectedImage == 1 ? "assets/cena.png" : "assets/romantico.jpg")));
        },
        child: const Icon(Icons.send_rounded),
      ),
    );
  }
}

