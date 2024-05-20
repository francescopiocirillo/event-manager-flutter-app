import 'package:event_manager_app/home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<void> deleteDatabase(String path) {
    print("deletedb" + path);
    return databaseFactory.deleteDatabase(path);
  }
  Future<Database> _initDatabase() async {
    print("INITDATABASE");
    //await deleteDatabase(join(await getDatabasesPath(), 'mio_database.db'));
    return openDatabase(
      join(await getDatabasesPath(), 'mio_database.db'),
      version: 1,
      onCreate: (db, version) async {
        print("ONCREATE");
        await db.execute(
          'CREATE TABLE event(title VARCHAR(20) PRIMARY KEY, description TEXT, startDate VARCHAR(50), endDate VARCHAR(50), startHour VARCHAR(50), expectedParticipants INT, actualParticipants INT, img varchar(30));',
        );
        await db.execute(
          'CREATE TABLE participant(name VARCHAR(20), last_name VARCHAR(20), birth VARCHAR(20), event_title VARCHAR(20), PRIMARY KEY(name, last_name), FOREIGN KEY(event_title) REFERENCES event(title) ON DELETE CASCADE);',
        );
        
      },
    );
  }

  Future<void> insertEvento(Event ev) async {
    final db = await database;
    print("sto inserendo evento");
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

  Future<int> deleteEvento(Event ev) async {
    final db = await database;
    print("elimina evento");
    List<Object?> ev_title = [ev.title];
    return db.delete("event", where: "title = ?", whereArgs: ev_title);
  }

  Future<void> insertParticipant(String eventTitle, Person participant) async {
    final db = await database;
    print("sto inserendo partecipante");
    final ev_participant_map = participant.toMap();
    ev_participant_map['event_title'] = eventTitle;
    await db.insert(
      'participant',
      ev_participant_map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateParticipants(String new_title, String old_title) async {
    final db = await database;
    return db.rawUpdate('UPDATE Participant SET event_title = ? WHERE NAME = ?', [new_title, old_title]);
  }

  Future<int> updateEvent(Event old_ev, Event new_ev) async {
    final db = await database;
    return db.update('event', new_ev.toMap(), where: 'title = ?', whereArgs: [old_ev.title]);
  }

  // Tutti gli altri metodi
  // ...
}