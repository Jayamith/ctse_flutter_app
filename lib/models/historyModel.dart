class History {

  static const tblHistory = 'history';
  static const colId = 'id';
  static const colLevel = 'level';
  static const colPluggedTime = 'pluggedTime';

  History({this.id, this.level, this.pluggedTime});

  History.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    level = map[colLevel];
    pluggedTime = map[colPluggedTime];
  }

  int? id;
  String? level;
  DateTime? pluggedTime;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {colLevel: level, colPluggedTime: pluggedTime};
    if (id != null) map[colId] = id;
    return map;
  }
}
