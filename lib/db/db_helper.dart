import 'package:ctse_app_life_saviour/models/appModel.dart';
import 'package:ctse_app_life_saviour/models/historyModel.dart';
import 'package:ctse_app_life_saviour/models/reminder_model.dart';
import 'package:ctse_app_life_saviour/models/notifier_model.dart';
import 'package:get/state_manager.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableNameReminder = "reminders";
  static const String _tableNameHistory = "history";
  static const String _tableNameNotifier = "notifier";
  static const String _tableNameOptimizer = "apps";

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
          )''');
          db.execute('''
            CREATE TABLE $_tableNameNotifier(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            level TEXT)''');
          db.execute('''
            CREATE TABLE $_tableNameOptimizer(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            appName STRING, 
            duration STRING )''');
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
    return await _database!.rawUpdate(''';
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
    List<Map> histories =
        await _database!.query(_tableNameHistory, orderBy: 'id DESC');
    print('History data retrieved:' + histories.length.toString());
    return histories.length == 0
        ? []
        : histories.map((e) => History.fromMap(e)).toList();
  }

  static Future<int?> deleteHistory(int? id) async {
    int? deletedId = await _database?.delete(_tableNameHistory,
        where: '${History.colId}=?', whereArgs: [id]);
    print('History deleted with ID:' + deletedId.toString());
    return deletedId;
  }

  static Future<int?> deleteAllHistory() async {
    int? deletedId = await _database?.delete(_tableNameHistory);
    print('All history deleted.');
    return deletedId;
  }

  static Future<int?> insertNotifier(Notifier notifier) async {
    int? id = await _database?.insert(_tableNameNotifier, notifier.toMap());
    print('Notifier inserted with ID:' + id.toString());
    return id;
  }

  static Future<List<Notifier>?> fetchNotifier() async {
    List<Map> notifiers =
        await _database!.query(_tableNameNotifier, orderBy: 'id DESC');
    print('Notifier data retrieved:' + notifiers.length.toString());
    return notifiers.length == 0
        ? []
        : notifiers.map((e) => Notifier.fromMap(e)).toList();
  }

  static Future<int?> deleteNotifier(int? id) async {
    int? deletedId = await _database?.delete(_tableNameNotifier,
        where: '${Notifier.notifyId}=?', whereArgs: [id]);
    print('Notifier deleted with ID:' + deletedId.toString());
    return deletedId;
  }

  static Future<int?> deleteAllNotifiers() async {
    int? deletedId = await _database?.delete(_tableNameNotifier);
    print('All notiifers deleted.');
    return deletedId;
  }

  //inserts a new app
  static Future<int> insertApp(App? app) async {
    print('insert function called');
    return await _database?.insert(_tableNameOptimizer,app!.toJson()) ?? 1;
  }

  //get all the app data
  static Future<List<Map<String, dynamic>>> getAppData() async {
    print('get function called');
    return await _database!.query(_tableNameOptimizer);
  }
  //update an app by Id
  static updateApp(int? id,String? duration) async {
    print('update function called');
    return await _database!.rawUpdate(''';
    UPDATE apps
    SET duration = ?
    WHERE id = ?
    ''', [duration, id]);
  }

  //Delete an app by id
  static deleteApp(int id) async {
    return await _database!
        .delete(_tableNameOptimizer, where: 'id=?', whereArgs: [id]);
  }
}
