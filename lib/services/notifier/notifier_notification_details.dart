import 'package:flutter/material.dart';

class NotificationDetail extends StatelessWidget {
  final String? label;
  const NotificationDetail({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Battery is Low, Connect Your Charger",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red[300],
      ),
      body: Center(
        child: Container(
          height: 600,
          width: 340,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.grey),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(
                    "Battery Level is : ${label.toString().split("|")[0]}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(
                  child: Text(
                    "Remind Time : ${label.toString().split("|")[1]}",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),    
        ),
      ),
    );
  }
}