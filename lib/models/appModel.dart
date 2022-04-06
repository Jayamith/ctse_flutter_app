class App {
  int? id;
  String? appName;
  String? duration;


  App(
      { this.id,
        this.appName,
        this.duration,
      });

  App.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appName = json['appName'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['appName'] = appName;
    data['duration'] = duration;
    return data;
  }
}
