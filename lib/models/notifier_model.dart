class Notifier {

  static const tableNotifier = 'notifier';
  static const notifyId = 'id';
  static const notifyLevel = 'level';

  Notifier({this.id, this.level});

  Notifier.fromMap(Map<dynamic, dynamic> map) {
    id = map[notifyId];
    level = map[notifyLevel];
  }

  int? id;
  String? level;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {notifyLevel: level};
    if (id != null) map[notifyId] = id;
    return map;
  }
}
