import 'package:flutter/material.dart';

class BatteryHistory extends StatelessWidget {
  const BatteryHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Battery History",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.purple[100],
      ),
      body: const Center(
        child: Text(
          "History Page",
        ),
      ),
    );
  }
}
