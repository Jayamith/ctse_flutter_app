import 'package:flutter/material.dart';

class BatteryNotifier extends StatelessWidget {
  const BatteryNotifier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Battery Notifier",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: const Center(
        child: Text(
          "Notifier Page",
        ),
      ),
    );
  }
}
