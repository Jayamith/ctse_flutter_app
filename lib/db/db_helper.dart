import 'package:ctse_app_life_saviour/models/reminder_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableNameReminder = "reminders";

  static Future<void> initDb() async {
    if (_database != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'life_savior.db';
      _database = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("Creating New Database");
          return db.execute(
            "CREATE TABLE $_tableNameReminder("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, description TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "isCompleted INTEGER, remindMe INTEGER, "
            "repeat STRING)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Reminder? reminder) async {
    print('insert function called');
    return await _database?.insert(_tableNameReminder, reminder!.toJson()) ?? 1;
  }
}
