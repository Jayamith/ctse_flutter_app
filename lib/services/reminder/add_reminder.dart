import 'package:flutter/material.dart';

class AddReminder extends StatelessWidget {
  const AddReminder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Reminder",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.cyanAccent,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
