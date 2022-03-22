class Notifier {
  String? id;
  String? status;
  String? level;
  int? remindMe;
  String? repeat;

  Notifier(
    {this.id,
      this.status,
      this.level,
      this.remindMe,
      this.repeat});

  Notifier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    level = json['level'];
    remindMe = json['remindMe'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['level'] = level;
    data['remindMe'] = remindMe;
    data['repeat'] = repeat;
    return data;
  }
}
