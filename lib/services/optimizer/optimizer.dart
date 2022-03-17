import 'package:flutter/material.dart';

class BatteryOptimizer extends StatelessWidget {
  const BatteryOptimizer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Battery Optimizer",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: const Center(
        child: Text(
          "Optimizer Page",
        ),
      ),
    );
  }
}
