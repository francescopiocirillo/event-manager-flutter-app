import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirty_green_events/event.dart';

class NewEvent extends StatefulWidget {
  final Event? event;
  final List<Event>? events;
  const NewEvent({super.key,  this.event, this.events});

  @override
  State<NewEvent> createState() => _NewEventState(event: event, events: events);
}

class _NewEventState extends State<NewEvent> {

  final Event? event;
  final List<Event>? events;
  final textNomeController = TextEditingController();
  final textDescrizioneController = TextEditingController();
  String pageTitle = "New event";
  String datePrompt = "Select dates of the event";
  String timePrompt = "Select event's beginning hour";
  int _selectedImage = 0;
  DateTimeRange selectedDates = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 12, minute: 00);
  double expectedParticipants = 0;
  final _formKey = GlobalKey<FormState>();

  /** la pagina deve essere diversa se si sta aggiungendo un nuovo evento
   * o modificando uno preesistente, per questo è stata implementata della
   * logica nel costruttore dello stato
   */
  _NewEventState({this.event, this.events}) {
    if(event != null){
      pageTitle= (event?.title)!;
      if(event?.img == "assets/lavoro.jpg"){
        _selectedImage = 0;
      }else{
        if(event?.img == "assets/cena.png"){
          _selectedImage = 1;
        }else{
          _selectedImage = 2;
        }
      }
      textNomeController.text = (event?.title)!;
      textDescrizioneController.text = (event?.description)!;
      expectedParticipants = (event?.expectedParticipants.toDouble())!;
      datePrompt = "Selected date:\n" + DateFormat("EEE, MMM d, yyyy").format((event?.startDate)!)+" / "+
          DateFormat("EEE, MMM d, yyyy").format((event?.startDate)!);
      timePrompt = "Selected hour: " + 
          DateFormat('h:mm a').format(DateTime(1,1,1, (event?.startHour.hour)!.toInt(), (event?.startHour.minute)!.toInt()));
    }
  }

  /** questa funzione mostra il DateRangePicker e opportunamente aggiorna lo stato
   * sulla base dell'input dell'utente
   */
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

  /** questa funzione mostra lo showTimePicker e opportunamente aggiorna lo stato
   * sulla base dell'input dell'utente
   */
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
      /** l'AppBar mostra il nome dell'evento in modifica oppure 'New event' 
       * se si sta aggiungendo un nuovo evento */
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(pageTitle, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 30, 
              color: Colors.teal.shade900 ),
                  ),
      ),
      body: SafeArea(
        child: SingleChildScrollView( /** per permettere la visualizzazione anche con lo schermo in orizzontale */
          child: Form( /** il form contiene come child una Column con children i vari campi per creare/modificare un evento */
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Choose your event's theme!",
                        style: TextStyle(color: Colors.teal, 
                                    fontSize: 20, 
                                    fontWeight: FontWeight.bold,)),
                ),
                Row( /** il tema si sceglie selezionando un'immagine tra le tre disponibili, questo setta la variabile _selectedImage */
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
                          decoration: BoxDecoration(
                            border: Border.all(/** il bordo dell'immagine cambia colore se questa è selezionata */
                              width: 3, 
                              color: _selectedImage == 0 ? 
                                Colors.red:Colors.transparent), 
                              shape: BoxShape.circle),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage("assets/lavoro.jpg"), 
                            radius: 60,),
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
                          child: const CircleAvatar(backgroundImage: AssetImage("assets/cena.png"), radius: 60,),
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
                          child: const CircleAvatar(backgroundImage: AssetImage("assets/romantico.jpg"), radius: 60,),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: textNomeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: 'Insert event name',
                    ),
                    /** il validor si assicura che venga inserito un nome valido (non sono ammessi duplicati) */
                    validator: (value) {
                      if(value == null || value.isEmpty || (event == null && events!.any((element) => element.title == textNomeController.text))){
                        return 'Please, insert event name (duplicate names not allowed)';
                      }
                      return null;
                    },
                  ), 
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: textDescrizioneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: 'Insert event description',
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please, insert event description';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("Insert number of expected participants"),
                ),
                Slider( /** per la selezione del numero di partecipanti si è scelto uno Slider */
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
                ElevatedButton( /** per la scelta della data e dell'ora ci sono appositi ElevatedButton che chiamano delle funzioni */
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
        ),
      ),
      /** questo button permette di aggiungere/modificare l'evento, 
       * validando i form e poi inviando l'evento alla pagina home dove vengono 
       * aggiornati il database e la lista visibile */
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_formKey.currentState!.validate()){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data are being processed...'), backgroundColor: Colors.teal),
            );
            Navigator.pop(context, Event(title: textNomeController.text, description: textDescrizioneController.text, 
            startDate: startDate, endDate: endDate, startHour: startTime, expectedParticipants: expectedParticipants.toInt(), 
            actualParticipants: 0, img: _selectedImage == 0 ? "assets/lavoro.jpg" : (_selectedImage == 1 ? "assets/cena.png" : "assets/romantico.jpg")));
          }
          },
        child: const Icon(Icons.send_rounded),
      ),
    );
  }
}

