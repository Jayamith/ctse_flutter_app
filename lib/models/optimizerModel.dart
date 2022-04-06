import 'package:flutter/cupertino.dart';

class Optimizer {

  int? id;
  String? name;
  Duration? usage;
  dynamic ? icon;


  Optimizer(
      { this.id,
        this.usage,
        this.name,
        this.icon
      });

Optimizer.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  usage = json['usage'];

}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = id;
  data['name'] = name;
  data['usage'] = usage;
  return data;
}
}
