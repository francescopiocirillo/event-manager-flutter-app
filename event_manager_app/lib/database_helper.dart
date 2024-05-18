import 'package:event_manager_app/home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'mio_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE event(title VARCHAR(20) PRIMARY KEY, description TEXT, startDate VARCHAR(50), endDate VARCHAR(50), startHour VARCHAR(50), expectedParticipants INT, actualParticipants INT, img varchar(30));',
        );
      },
      version: 1,
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
  }

  // Tutti gli altri metodi
  // ...
}