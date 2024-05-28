import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:thirty_green_events/event.dart';
import 'package:thirty_green_events/person.dart';

class DatabaseHelper {
  /** la connessione al database è stata gestita per mezzo di un Singleton */
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  /** questa lista contiene degli eventi di esempio che vengono inseriti in automatico
   * in modo da permettere una valutazione agevole dell'app
   */
  List<Event> events = [
    Event(
      title: 'Workshop di Fotografia',
      description:
          'Un workshop intensivo per imparare le basi della fotografia, dalle tecniche di composizione all\'uso delle luci, ideale per chi desidera migliorare le proprie competenze fotografiche.',
      startDate: DateTime(2024, 1, 7, 00, 00),
      endDate: DateTime(2024, 1, 10, 00, 00),
      startHour: TimeOfDay(hour: 10, minute: 00),
      expectedParticipants: 15,
      actualParticipants: 10,
      img: 'assets/lavoro.jpg',
      participants: [
        Person(name: "Mario", lastName: "Pascale", birth: DateTime(1998, 01, 01)),
        Person(name: "Luigi", lastName: "Rossi", birth: DateTime(1988, 01, 02)),
        Person(name: "Marco", lastName: "Ferrari", birth: DateTime(1997, 02, 03)),
        Person(name: "Anna", lastName: "Esposito", birth: DateTime(2000, 03, 01)),
        Person(name: "Luca", lastName: "Prio", birth: DateTime(2002, 09, 02)),
        Person(name: "Paolo", lastName: "Conti", birth: DateTime(1999, 04, 03)),
        Person(name: "Giulia", lastName: "Ricci", birth: DateTime(1997, 01, 10)),
        Person(name: "Carmine", lastName: "Bianchi", birth: DateTime(2003, 07, 01)),
        Person(name: "Laura", lastName: "Gallo", birth: DateTime(2000, 08, 20)),
        Person(name: "Gloria", lastName: "Neri", birth: DateTime(1999, 08, 30)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Corso di Cucina Vegana',
      description: 'Un corso pratico in cui imparerai a preparare deliziose ricette vegane, esplorando ingredienti innovativi e tecniche culinarie per una cucina sana e gustosa.',
      startDate: DateTime(2024, 2, 11, 08, 30),
      endDate: DateTime(2024, 2, 7, 15, 30),
      startHour: TimeOfDay(hour: 14, minute: 30),
      expectedParticipants: 20,
      actualParticipants: 10,
      img: 'assets/cena.png',
      participants: [
        Person(name: "Mario", lastName: "Pascale", birth: DateTime(1998, 01, 01)),
        Person(name: "Luigi", lastName: "Rossi", birth: DateTime(1988, 01, 02)),
        Person(name: "Marco", lastName: "Ferrari", birth: DateTime(1997, 02, 03)),
        Person(name: "Anna", lastName: "Esposito", birth: DateTime(2000, 03, 01)),
        Person(name: "Luca", lastName: "Prio", birth: DateTime(2002, 09, 02)),
        Person(name: "Paolo", lastName: "Conti", birth: DateTime(1999, 04, 03)),
        Person(name: "Giulia", lastName: "Ricci", birth: DateTime(1997, 01, 10)),
        Person(name: "Carmine", lastName: "Bianchi", birth: DateTime(2003, 07, 01)),
        Person(name: "Laura", lastName: "Gallo", birth: DateTime(2000, 08, 20)),
        Person(name: "Gloria", lastName: "Neri", birth: DateTime(1999, 08, 30)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Seminario di Scrittura Creativa',
      description: 'Un seminario dedicato agli scrittori in erba e ai professionisti che vogliono affinare le loro abilità narrative, con esercizi pratici e consigli da esperti del settore.',
      startDate: DateTime(2024, 3, 12, 08, 30),
      endDate: DateTime(2024, 3, 15, 15, 30),
      startHour: TimeOfDay(hour: 09, minute: 10),
      expectedParticipants: 25,
      actualParticipants: 23,
      img: 'assets/lavoro.jpg',
      participants: [
        Person(name: "Valentina", lastName: "Scartori", birth: DateTime(1998, 01, 01)),
        Person(name: "Stefano", lastName: "Marchetti", birth: DateTime(1998, 01, 02)),
        Person(name: "Alice", lastName: "Marino", birth: DateTime(1998, 01, 03)),
        Person(name: "Francesca", lastName: "Parisi", birth: DateTime(1998, 01, 01)),
        Person(name: "Matteo", lastName: "Fontana", birth: DateTime(1998, 01, 01)),
        Person(name: "Roberto", lastName: "Galli", birth: DateTime(1998, 01, 02)),
        Person(name: "Federica", lastName: "Pascallo", birth: DateTime(1998, 01, 03)),
        Person(name: "Luisa", lastName: "Vitale", birth: DateTime(1998, 01, 01)),
        Person(name: "Elisa", lastName: "Benedetti", birth: DateTime(1998, 01, 02)),
        Person(name: "Claudia", lastName: "Bruno", birth: DateTime(1998, 01, 01)),
        Person(name: "Martina", lastName: "Pugliese", birth: DateTime(1998, 01, 02)),
        Person(name: "Giovanni", lastName: "Ferri", birth: DateTime(1998, 01, 03)),
        Person(name: "Chiara", lastName: "Giordano", birth: DateTime(1998, 01, 01)),
        Person(name: "Elena", lastName: "Costa", birth: DateTime(1998, 01, 01)),
        Person(name: "Simone", lastName: "Pierri", birth: DateTime(1998, 01, 02)),
        Person(name: "Andrea", lastName: "Moretti", birth: DateTime(1998, 01, 03)),
        Person(name: "Mario", lastName: "Apice", birth: DateTime(1998, 01, 01)),
        Person(name: "Lucia", lastName: "Apice", birth: DateTime(1998, 01, 02)),
        Person(name: "Maria", lastName: "Apice", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        Person(name: "Paolo", lastName: "Conti", birth: DateTime(1999, 04, 03)),
        Person(name: "Giulia", lastName: "Ricci", birth: DateTime(1997, 01, 10)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Introduzione alla Meditazione al tramonto',
      description: 'Un\'introduzione rilassante alla pratica della meditazione, perfetta per coppie che desiderano connettersi in un ambiente tranquillo e suggestivo al tramonto.',
      startDate: DateTime(2024, 4, 12, 08, 30),
      endDate: DateTime(2024, 4, 15, 15, 30),
      startHour: TimeOfDay(hour: 18, minute: 10),
      expectedParticipants: 9,
      actualParticipants: 7,
      img: 'assets/romantico.jpg',
      participants: [
        Person(name: "Valentina", lastName: "Scartori", birth: DateTime(1998, 01, 01)),
        Person(name: "Stefano", lastName: "Marchetti", birth: DateTime(1998, 01, 02)),
        Person(name: "Alice", lastName: "Marino", birth: DateTime(1998, 01, 03)),
        Person(name: "Mario", lastName: "Lombardi", birth: DateTime(1998, 01, 01)),
        Person(name: "Lucia", lastName: "Moretti", birth: DateTime(1998, 01, 02)),
        Person(name: "Maria", lastName: "Rizzo", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Corso di Primo Soccorso',
      description: 'Un corso pratico e teorico per apprendere le tecniche di base del primo soccorso, fondamentale per garantire la sicurezza in vari contesti lavorativi e personali.',
      startDate: DateTime(2024, 5, 22, 08, 30),
      endDate: DateTime(2024, 5, 25, 15, 30),
      startHour: TimeOfDay(hour: 09, minute: 10),
      expectedParticipants: 30,
      actualParticipants: 14,
      img: 'assets/lavoro.jpg',
      participants: [
        Person(name: "Mario", lastName: "Apice", birth: DateTime(1998, 01, 01)),
        Person(name: "Lucia", lastName: "Apice", birth: DateTime(1998, 01, 02)),
        Person(name: "Maria", lastName: "Apice", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        Person(name: "Paolo", lastName: "Conti", birth: DateTime(1999, 04, 03)),
        Person(name: "Giulia", lastName: "Ricci", birth: DateTime(1997, 01, 10)),
        Person(name: "Carmine", lastName: "Bianchi", birth: DateTime(2003, 07, 01)),
        Person(name: "Laura", lastName: "Gallo", birth: DateTime(2000, 08, 20)),
        Person(name: "Gloria", lastName: "Neri", birth: DateTime(1999, 08, 30)),
        Person(name: "Mario", lastName: "Pascale", birth: DateTime(1998, 01, 01)),
        Person(name: "Luigi", lastName: "Rossi", birth: DateTime(1988, 01, 02)),
        Person(name: "Marco", lastName: "Ferrari", birth: DateTime(1997, 02, 03)),
        Person(name: "Anna", lastName: "Esposito", birth: DateTime(2000, 03, 01)),
        Person(name: "Luca", lastName: "Prio", birth: DateTime(2002, 09, 02)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Creazioni in Ceramica per Coppie',
      description: 'Un laboratorio artistico dove le coppie possono sperimentare insieme la creazione di oggetti in ceramica, godendo di un\'attività manuale e creativa.',
      startDate: DateTime(2024, 6, 6, 08, 30),
      endDate: DateTime(2024, 6, 14, 15, 30),
      startHour: TimeOfDay(hour: 11, minute: 10),
      expectedParticipants: 8,
      actualParticipants: 6,
      img: 'assets/romantico.jpg',
      participants: [
        Person(name: "Mario", lastName: "Apice", birth: DateTime(1998, 01, 01)),
        Person(name: "Lucia", lastName: "Apice", birth: DateTime(1998, 01, 02)),
        Person(name: "Maria", lastName: "Apice", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        Person(name: "Anna", lastName: "Esposito", birth: DateTime(2000, 03, 01)),
        Person(name: "Luca", lastName: "Prio", birth: DateTime(2002, 09, 02)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Passeggiata Naturalistica',
      description: 'Una giornata immersa nella natura, esplorando paesaggi incantevoli e scoprendo flora e fauna locali, ideale per coppie che amano l\'avventura e il relax.',
      startDate: DateTime(2024, 7, 6, 08, 30),
      endDate: DateTime(2024, 7, 6, 15, 30),
      startHour: TimeOfDay(hour: 6, minute: 00),
      expectedParticipants: 27,
      actualParticipants: 11,
      img: 'assets/romantico.jpg',
      participants: [
        Person(name: "Mario", lastName: "Apice", birth: DateTime(1998, 01, 01)),
        Person(name: "Lucia", lastName: "Apice", birth: DateTime(1998, 01, 02)),
        Person(name: "Maria", lastName: "Apice", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        Person(name: "Paolo", lastName: "Conti", birth: DateTime(1999, 04, 03)),
        Person(name: "Giulia", lastName: "Ricci", birth: DateTime(1997, 01, 10)),
        Person(name: "Carmine", lastName: "Bianchi", birth: DateTime(2003, 07, 01)),
        Person(name: "Laura", lastName: "Gallo", birth: DateTime(2000, 08, 20)),
        Person(name: "Gloria", lastName: "Neri", birth: DateTime(1999, 08, 30)),
        Person(name: "Mario", lastName: "Pascale", birth: DateTime(1998, 01, 01)),
        Person(name: "Luigi", lastName: "Rossi", birth: DateTime(1988, 01, 02)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Yoga all\'alba',
      description: 'Una lezione di yoga al sorgere del sole, perfetta per iniziare la giornata con energia positiva e condividere un momento di benessere con il partner.',
      startDate: DateTime(2024, 8, 16, 08, 30),
      endDate: DateTime(2024, 8, 16, 15, 30),
      startHour: TimeOfDay(hour: 6, minute: 00),
      expectedParticipants: 15,
      actualParticipants: 11,
      img: 'assets/romantico.jpg',
      participants: [
        Person(name: "Mario", lastName: "Apice", birth: DateTime(1998, 01, 01)),
        Person(name: "Lucia", lastName: "Apice", birth: DateTime(1998, 01, 02)),
        Person(name: "Maria", lastName: "Apice", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        Person(name: "Paolo", lastName: "Conti", birth: DateTime(1999, 04, 03)),
        Person(name: "Giulia", lastName: "Ricci", birth: DateTime(1997, 01, 10)),
        Person(name: "Carmine", lastName: "Bianchi", birth: DateTime(2003, 07, 01)),
        Person(name: "Laura", lastName: "Gallo", birth: DateTime(2000, 08, 20)),
        Person(name: "Gloria", lastName: "Neri", birth: DateTime(1999, 08, 30)),
        Person(name: "Mario", lastName: "Pascale", birth: DateTime(1998, 01, 01)),
        Person(name: "Luigi", lastName: "Rossi", birth: DateTime(1988, 01, 02)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Degustazione di Vini e Formaggi',
      description: 'Un\'esperienza enogastronomica dedicata agli amanti del buon cibo e del vino. Durante l\'evento, esperti sommelier guideranno i partecipanti attraverso una selezione di vini pregiati, abbinati a formaggi artigianali di alta qualità. Ogni vino verrà degustato insieme a formaggi accuratamente scelti per esaltarne i sapori e le caratteristiche uniche. I partecipanti avranno l\'opportunità di apprendere le tecniche di degustazione, comprendere le diverse tipologie di vini e formaggi, e scoprire come creare perfetti abbinamenti culinari. Un\'occasione perfetta per apprezzare l\'arte del buon vivere in un\'atmosfera rilassata e conviviale.',
      startDate: DateTime(2024, 9, 16, 08, 30),
      endDate: DateTime(2024, 9, 26, 15, 30),
      startHour: TimeOfDay(hour: 21, minute: 00),
      expectedParticipants: 20,
      actualParticipants: 20,
      img: 'assets/cena.png',
      participants: [
        Person(name: "Valentina", lastName: "Scartori", birth: DateTime(1998, 01, 01)),
        Person(name: "Stefano", lastName: "Marchetti", birth: DateTime(1998, 01, 02)),
        Person(name: "Alice", lastName: "Marino", birth: DateTime(1998, 01, 03)),
        Person(name: "Francesca", lastName: "Parisi", birth: DateTime(1998, 01, 01)),
        Person(name: "Matteo", lastName: "Fontana", birth: DateTime(1998, 01, 01)),
        Person(name: "Roberto", lastName: "Galli", birth: DateTime(1998, 01, 02)),
        Person(name: "Federica", lastName: "Pascallo", birth: DateTime(1998, 01, 03)),
        Person(name: "Luisa", lastName: "Vitale", birth: DateTime(1998, 01, 01)),
        Person(name: "Elisa", lastName: "Benedetti", birth: DateTime(1998, 01, 02)),
        Person(name: "Claudia", lastName: "Bruno", birth: DateTime(1998, 01, 01)),
        Person(name: "Martina", lastName: "Pugliese", birth: DateTime(1998, 01, 02)),
        Person(name: "Giovanni", lastName: "Ferri", birth: DateTime(1998, 01, 03)),
        Person(name: "Chiara", lastName: "Giordano", birth: DateTime(1998, 01, 01)),
        Person(name: "Elena", lastName: "Costa", birth: DateTime(1998, 01, 01)),
        Person(name: "Simone", lastName: "Pierri", birth: DateTime(1998, 01, 02)),
        Person(name: "Andrea", lastName: "Moretti", birth: DateTime(1998, 01, 03)),
        Person(name: "Mario", lastName: "Apice", birth: DateTime(1998, 01, 01)),
        Person(name: "Lucia", lastName: "Apice", birth: DateTime(1998, 01, 02)),
        Person(name: "Maria", lastName: "Apice", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Introduzione alla Programmazione con Python',
      description: 'Un\'introduzione pratica e teorica alla programmazione con Python, pensata per principianti che vogliono avvicinarsi al mondo dello sviluppo software.',
      startDate: DateTime(2024, 10, 29, 08, 30),
      endDate: DateTime(2024, 10, 31, 15, 30),
      startHour: TimeOfDay(hour: 8, minute: 00),
      expectedParticipants: 5,
      actualParticipants: 5,
      img: 'assets/lavoro.jpg',
      participants: [
        Person(name: "Maria", lastName: "Apice", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        Person(name: "Paolo", lastName: "Conti", birth: DateTime(1999, 04, 03)),
        Person(name: "Giulia", lastName: "Ricci", birth: DateTime(1997, 01, 10)),
        Person(name: "Claudia", lastName: "Bruno", birth: DateTime(1998, 01, 01)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Laboratorio di Pasticceria Artigianale',
      description: 'Un laboratorio per principianti che vogliono esplorare le basi del disegno artistico, migliorando le proprie capacità espressive e tecniche.',
      startDate: DateTime(2024, 11, 15, 08, 30),
      endDate: DateTime(2024, 11, 25, 15, 30),
      startHour: TimeOfDay(hour: 14, minute: 00),
      expectedParticipants: 25,
      actualParticipants: 21,
      img: 'assets/cena.png',
      participants: [
        Person(name: "Claudia", lastName: "Bruno", birth: DateTime(1998, 01, 01)),
        Person(name: "Martina", lastName: "Pugliese", birth: DateTime(1998, 01, 02)),
        Person(name: "Giovanni", lastName: "Ferri", birth: DateTime(1998, 01, 03)),
        Person(name: "Chiara", lastName: "Giordano", birth: DateTime(1998, 01, 01)),
        Person(name: "Elena", lastName: "Costa", birth: DateTime(1998, 01, 01)),
        Person(name: "Simone", lastName: "Pierri", birth: DateTime(1998, 01, 02)),
        Person(name: "Andrea", lastName: "Moretti", birth: DateTime(1998, 01, 03)),
        Person(name: "Mario", lastName: "Apice", birth: DateTime(1998, 01, 01)),
        Person(name: "Lucia", lastName: "Apice", birth: DateTime(1998, 01, 02)),
        Person(name: "Maria", lastName: "Apice", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        Person(name: "Paolo", lastName: "Conti", birth: DateTime(1999, 04, 03)),
        Person(name: "Giulia", lastName: "Ricci", birth: DateTime(1997, 01, 10)),
        Person(name: "Carmine", lastName: "Bianchi", birth: DateTime(2003, 07, 01)),
        Person(name: "Laura", lastName: "Gallo", birth: DateTime(2000, 08, 20)),
        Person(name: "Gloria", lastName: "Neri", birth: DateTime(1999, 08, 30)),
        Person(name: "Mario", lastName: "Pascale", birth: DateTime(1998, 01, 01)),
        Person(name: "Luigi", lastName: "Rossi", birth: DateTime(1988, 01, 02)),
        Person(name: "Marco", lastName: "Ferrari", birth: DateTime(1997, 02, 03)),
        Person(name: "Anna", lastName: "Esposito", birth: DateTime(2000, 03, 01)),
        Person(name: "Luca", lastName: "Prio", birth: DateTime(2002, 09, 02)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
    Event(
      title: 'Capodanno in baita',
      description: 'Festeggia l\'arrivo del nuovo anno in una pittoresca baita di montagna, circondato dalla magia della neve e da un\'atmosfera intima e romantica. L\'evento inizia con una cena gourmet preparata da chef esperti, che delizieranno i partecipanti con piatti raffinati e ingredienti di stagione. Dopo cena, ci sarà una serata di musica dal vivo e balli accanto al camino, creando un ambiente caldo e accogliente. Allo scoccare della mezzanotte, un brindisi speciale sotto le stelle e uno spettacolo pirotecnico illumineranno il cielo, dando il benvenuto al nuovo anno. Per chi desidera un momento di relax, la baita offre anche una spa con sauna e idromassaggio. Un\'esperienza indimenticabile per celebrare il Capodanno in compagnia di persone care, in un luogo incantevole.',
      startDate: DateTime(2024, 12, 30, 08, 30),
      endDate: DateTime(2025, 1, 3, 15, 30),
      startHour: TimeOfDay(hour: 21, minute: 30),
      expectedParticipants: 30,
      actualParticipants: 30,
      img: 'assets/cena.png',
      participants: [
        Person(name: "Valentina", lastName: "Scartori", birth: DateTime(1998, 01, 01)),
        Person(name: "Stefano", lastName: "Marchetti", birth: DateTime(1998, 01, 02)),
        Person(name: "Alice", lastName: "Marino", birth: DateTime(1998, 01, 03)),
        Person(name: "Francesca", lastName: "Parisi", birth: DateTime(1998, 01, 01)),
        Person(name: "Matteo", lastName: "Fontana", birth: DateTime(1998, 01, 01)),
        Person(name: "Roberto", lastName: "Galli", birth: DateTime(1998, 01, 02)),
        Person(name: "Federica", lastName: "Pascallo", birth: DateTime(1998, 01, 03)),
        Person(name: "Luisa", lastName: "Vitale", birth: DateTime(1998, 01, 01)),
        Person(name: "Elisa", lastName: "Benedetti", birth: DateTime(1998, 01, 02)),
        Person(name: "Claudia", lastName: "Bruno", birth: DateTime(1998, 01, 01)),
        Person(name: "Martina", lastName: "Pugliese", birth: DateTime(1998, 01, 02)),
        Person(name: "Giovanni", lastName: "Ferri", birth: DateTime(1998, 01, 03)),
        Person(name: "Chiara", lastName: "Giordano", birth: DateTime(1998, 01, 01)),
        Person(name: "Elena", lastName: "Costa", birth: DateTime(1998, 01, 01)),
        Person(name: "Simone", lastName: "Pierri", birth: DateTime(1998, 01, 02)),
        Person(name: "Andrea", lastName: "Moretti", birth: DateTime(1998, 01, 03)),
        Person(name: "Mario", lastName: "Apice", birth: DateTime(1998, 01, 01)),
        Person(name: "Lucia", lastName: "Apice", birth: DateTime(1998, 01, 02)),
        Person(name: "Maria", lastName: "Apice", birth: DateTime(1998, 01, 03)),
        Person(name: "Ugo", lastName: "Apice", birth: DateTime(2000, 02, 01)),
        Person(name: "Paolo", lastName: "Conti", birth: DateTime(1999, 04, 03)),
        Person(name: "Giulia", lastName: "Ricci", birth: DateTime(1997, 01, 10)),
        Person(name: "Carmine", lastName: "Bianchi", birth: DateTime(2003, 07, 01)),
        Person(name: "Laura", lastName: "Gallo", birth: DateTime(2000, 08, 20)),
        Person(name: "Gloria", lastName: "Neri", birth: DateTime(1999, 08, 30)),
        Person(name: "Mario", lastName: "Pascale", birth: DateTime(1998, 01, 01)),
        Person(name: "Luigi", lastName: "Rossi", birth: DateTime(1988, 01, 02)),
        Person(name: "Marco", lastName: "Ferrari", birth: DateTime(1997, 02, 03)),
        Person(name: "Anna", lastName: "Esposito", birth: DateTime(2000, 03, 01)),
        Person(name: "Luca", lastName: "Prio", birth: DateTime(2002, 09, 02)),
        ]
      /*img: File('./storage/emulated/0/Pictures/IMG_20240508_104350.jpg'),*/
    ),
  ];

  /** funzione per l'eliminazione del database */
  Future<void> deleteDatabase(String path) {
    return databaseFactory.deleteDatabase(path);
  }

  /** funzione per l'inizializzazione del database */
  Future<Database> _initDatabase() async {
    //await deleteDatabase(join(await getDatabasesPath(), 'mio_database.db'));
    return openDatabase(
      join(await getDatabasesPath(), 'mio_database.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE event(title VARCHAR(20) PRIMARY KEY, description TEXT, startDate VARCHAR(50), endDate VARCHAR(50), startHour VARCHAR(50), expectedParticipants INT, actualParticipants INT, img varchar(30));',
        );
        await db.execute(
          'CREATE TABLE participant(name VARCHAR(20), last_name VARCHAR(20), birth VARCHAR(20), event_title VARCHAR(20), PRIMARY KEY(name, last_name, event_title), FOREIGN KEY(event_title) REFERENCES event(title) ON DELETE CASCADE);',
        );
        /** il seguente ciclo for serve a popolare il db con degli eventi di default per permettere una valutazione agevole dell'app */
        for(Event ev in events) {
          await insertEventoForDB(ev, db);
        }
      },
    );  
  }
  
  /** questa funzione permette l'inserimento di un evento */
  Future<void> insertEvento(Event ev) async {
    final db = await database;
    insertEventoForDB(ev, db);
  }

  /** questa funzione permette l'inserimento di un evento prima
   * dell'inizializzazione dell'attributo database, utile nello
   * specifico per il popolamento di default del database nella
   * funzione onCreate
   */
  Future<void> insertEventoForDB(Event ev, Database db) async {
    await db.insert(
      'event',
      ev.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final ev_participants = ev.participants;
    for (Person ev_participant in ev_participants) {
      final ev_participant_map = ev_participant.toMap();
      ev_participant_map['event_title'] = ev.title;
      await db.insert(
        'participant',
        ev_participant_map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /** questa funzione permette l'eliminazione di un evento dal db */
  Future<int> deleteEvento(Event ev) async {
    final db = await database;
    List<Object?> ev_title = [ev.title];
    return db.delete("event", where: "title = ?", whereArgs: ev_title);
  }

  /** questa funzione permette l'aggiornamento di un evento nel db */
  Future<int> updateEvent(Event old_ev, Event new_ev) async {
    final db = await database;
    return db.update('event', new_ev.toMap(), where: 'title = ?', whereArgs: [old_ev.title]);
  }

  /** questa funzione permette l'inserimento di un partecipante al db */
  Future<void> insertParticipant(String eventTitle, Person participant) async {
    final db = await database;
    final ev_participant_map = participant.toMap();
    ev_participant_map['event_title'] = eventTitle;
    await db.insert(
      'participant',
      ev_participant_map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /** questa funzione permette l'aggiornamento di un partecipante nel db */
  Future<int> updateParticipants(String new_title, String old_title) async {
    final db = await database;
    return db.rawUpdate('UPDATE Participant SET event_title = ? WHERE NAME = ?', [new_title, old_title]);
  }
}