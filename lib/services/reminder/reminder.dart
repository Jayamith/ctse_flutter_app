import 'package:flutter/material.dart';

class BatteryReminder extends StatelessWidget {
  const BatteryReminder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Battery Reminder",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.cyanAccent,
      ),
      body: const Center(
        child: Text(
          "Reminder Page",
        ),
      ),
    );
  }
}
