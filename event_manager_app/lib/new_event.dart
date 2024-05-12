import 'package:event_manager_app/event_detail_page.dart';
import 'package:event_manager_app/home_page.dart';
import 'package:flutter/material.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({super.key});

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final textNomeController = TextEditingController();
  final textDescrizioneController = TextEditingController();
/*
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

    selectedDateTime = selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
*/
  DateTimeRange selectedDates= DateTimeRange(start: DateTime.now(), end: DateTime.now());
  DateTime startDate= DateTime.now();
  DateTime endDate= DateTime.now();
  TimeOfDay startTime= TimeOfDay(hour: 12, minute: 00);

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
      });
    }
  }

  Future<TimeOfDay?> selectedTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay(minute: 00, hour: 00)
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
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
              onPressed: () => _selectDates(context),
              child: Text('Select event\'s date'),
            ),
            ElevatedButton(
              onPressed: () => selectedTime(context),
              child: Text('Select event\'s start hour'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, Event(title: textNomeController.text, desctiption: textDescrizioneController.text, 
          completed: false, date: startDate, expectedParticipants: 3, actualParticipants: 0));
        },
        child: const Icon(Icons.send_rounded),
      ),
    );
  }
}

