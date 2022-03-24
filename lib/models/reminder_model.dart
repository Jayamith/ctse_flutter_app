class Reminder {
  int? id;
  String? title;
  String? date;
  String? startTime;
  int? isCompleted;
  int? remindMe;
  String? repeat;

  Reminder(
      {this.id,
      this.title,
      this.date,
      this.startTime,
      this.isCompleted,
      this.remindMe,
      this.repeat});

  Reminder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    startTime = json['startTime'];
    isCompleted = json['isCompleted'];
    remindMe = json['remindMe'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['startTime'] = startTime;
    data['isCompleted'] = isCompleted;
    data['remindMe'] = remindMe;
    data['repeat'] = repeat;
    return data;
  }
}
