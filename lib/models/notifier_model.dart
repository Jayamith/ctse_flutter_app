class Notifier {
  int? id;
  int? level;
  int? isCompleted;
  String? repeat;

  Notifier(
    {this.id,
      this.level,
      this.isCompleted,
      this.repeat});

  Notifier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    isCompleted = json['isCompleted'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['level'] = level;
    data['isCompleted'] = isCompleted;
    data['repeat'] = repeat;
    return data;
  }
}
