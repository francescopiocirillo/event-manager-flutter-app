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
  String dateTimePrompt = "Select date/time of the event";

  Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    setState(() {
      selectedDateTime = selectedTime == null
          ? selectedDate
          : DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
      
      dateTimePrompt = "Selected date/time: " + DateFormat('yyyy-MM-dd – kk:mm').format(selectedDateTime);;
    });
    
  }

  DateTime selectedDateTime = DateTime.now();
/*  

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101)
    );
    if ( picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
*/
  @override
  void dispose() {
    textNomeController.dispose();
    textDescrizioneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent[700],
        centerTitle: true,
        title: Text('Event Manager'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
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
                maxLines: 8,
              ),
            ),
            ElevatedButton(
              onPressed: () => showDateTimePicker(context: context), 
              child: Text(dateTimePrompt),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, Event(title: textNomeController.text, desctiption: textDescrizioneController.text, 
          completed: false, date: selectedDateTime, expectedParticipants: 3, actualParticipants: 0));
        },
        child: const Icon(Icons.send_rounded),
      ),
    );
  }
}

