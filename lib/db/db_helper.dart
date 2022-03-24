import 'package:ctse_app_life_saviour/models/historyModel.dart';
import 'package:ctse_app_life_saviour/models/reminder_model.dart';
import 'package:get/state_manager.dart';
import 'package:sqflite/sqflite.dart';

import '../models/notifier_model.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableNameReminder = "reminders";
  static const String _tableNameHistory = "history";
  static const String _tableNameNotifier = "notifier";

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
          db.execute(
            "CREATE TABLE $_tableNameReminder("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, description TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "isCompleted INTEGER, remindMe INTEGER, "
            "repeat STRING)",
          );
          db.execute('''
          CREATE TABLE $_tableNameHistory (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          level TEXT,
          pluggedTime STRING
          )'''
          );
          db.execute(
            "CREATE TABLE $_tableNameNotifier("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "status STRING, level STRING, "
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

  static Future<List<Map<String, dynamic>>> getData() async {
    print('get function called');
    return await _database!.query(_tableNameReminder);
  }

  static delete(Reminder reminder) async {
    return await _database!
        .delete(_tableNameReminder, where: 'id=?', whereArgs: [reminder.id]);
  }

  static Future<int?> insertHistory(History history) async {
    return await _database?.insert(_tableNameHistory, history.toMap());
  }

  static Future<int> insertNotifier(Notifier? notifier) async {
    return await _database?.insert(_tableNameNotifier, notifier!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> getNotifier() async {
    return await _database!.query(_tableNameNotifier);
  }

  static deleteNotifier(Notifier notifier) async {
    return await _database!
        .delete(_tableNameNotifier, where: 'id=?', whereArgs: [notifier.id]);
  }
}
