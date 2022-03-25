class Notifier {
  int? id;
  String? level;
  int? isCompleted;
  int? remindMe;

  Notifier(
    {this.id,
      this.level,
      this.isCompleted,
      this.remindMe});

  Notifier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    isCompleted = json['isCompleted'];
    remindMe = json['remindMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['level'] = level;
    data['isCompleted'] = isCompleted;
    data['remindMe'] = remindMe;
    return data;
  }
}
