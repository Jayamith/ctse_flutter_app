class Notifier {
  int? id;
  int? level;
  int? isCompleted;

  Notifier(
    {this.id,
      this.level,
      this.isCompleted});

  Notifier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['level'] = level;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
