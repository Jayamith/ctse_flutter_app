class Reminder {
  int? id;
  String? title;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  int? isCompleted;
  int? remindMe;
  String? repeat;

  Reminder(
      {this.id,
      this.title,
      this.description,
      this.date,
      this.startTime,
      this.endTime,
      this.isCompleted,
      this.remindMe,
      this.repeat});

  Reminder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    isCompleted = json['isCompleted'];
    remindMe = json['remindMe'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['isCompleted'] = isCompleted;
    data['remindMe'] = remindMe;
    data['repeat'] = repeat;
    return data;
  }
}
