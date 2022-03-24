class Notifier {
  String? id;
  String? status;
  String? level;
  int? isCompleted;
  int? remindMe;
  String? repeat;

  Notifier(
    {this.id,
      this.status,
      this.level,
      this.isCompleted,
      this.remindMe,
      this.repeat});

  Notifier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    level = json['level'];
    isCompleted = json['isCompleted'];
    remindMe = json['remindMe'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['level'] = level;
    data['isCompleted'] = isCompleted;
    data['remindMe'] = remindMe;
    data['repeat'] = repeat;
    return data;
  }
}
