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
            "title STRING, date STRING, "
            "startTime STRING, "
            "isCompleted INTEGER, remindMe INTEGER, "
            "repeat STRING)",
          );
          db.execute('''
          CREATE TABLE $_tableNameHistory (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          level TEXT,
          pluggedTime STRING
<<<<<<< HEAD
          )'''
          );
          db.execute(
            "CREATE TABLE $_tableNameNotifier("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "status STRING, level STRING, "
            "isCompleted INTEGER, remindMe INTEGER, "
            "repeat STRING)",
          );
=======
          )''');
>>>>>>> 6a26eb0e78204f6b9e3597a7c74dee4fa81953b6
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

  static update(int id) async {
    return await _database!.rawUpdate('''
    UPDATE reminders
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }

  static delete(Reminder reminder) async {
    return await _database!
        .delete(_tableNameReminder, where: 'id=?', whereArgs: [reminder.id]);
  }

  static Future<int?> insertHistory(History history) async {
    int? id = await _database?.insert(_tableNameHistory, history.toMap());
    print('History inserted with ID:' + id.toString());
    return id;
  }

  static Future<List<History>?> fetchHistory() async {
    List<Map> histories = await _database!.query(_tableNameHistory);
    print('History data retrieved:' + histories.length.toString());
    return histories.length == 0
        ? []
        : histories.map((e) => History.fromMap(e)).toList();
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

  static updateNotifier(int id) async {
    return await _database!.rawUpdate('''
    UPDATE notifiers
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}
