class Notifier {
  String? id;
  String? level;
  int? isCompleted;
  int? remindMe;
  String? repeat;

  Notifier(
    {this.id,
      this.level,
      this.isCompleted,
      this.remindMe,
      this.repeat});

  Notifier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    isCompleted = json['isCompleted'];
    remindMe = json['remindMe'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['level'] = level;
    data['isCompleted'] = isCompleted;
    data['remindMe'] = remindMe;
    data['repeat'] = repeat;
    return data;
  }
}
