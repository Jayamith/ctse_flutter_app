import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationInfo extends StatefulWidget {
  final String? label;
  const NotificationInfo({Key? key, required this.label}) : super(key: key);

  @override
  State<NotificationInfo> createState() => _NotificationInfoState();
}

class _NotificationInfoState extends State<NotificationInfo> {
  final Battery battery = Battery();
  int batteryPercentage = 100;
  BatteryState? batteryState;
  StreamSubscription<BatteryState>? batteryStreamSubscription;

  @override
  void initState() {
    super.initState();
    listenBatteryLevel();
    listenBatteryState();
  }

  void listenBatteryLevel() {
    updateBatteryLevel();
  }

  void listenBatteryState() => batteryStreamSubscription =
          battery.onBatteryStateChanged.listen((BatteryState state) {
        setState(() {
          batteryState = state;
        });
      });

  Future updateBatteryLevel() async {
    final bLevel = await battery.batteryLevel;
    setState(() {
      batteryPercentage = bLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Charge Your Mobile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.45,
          margin: const EdgeInsets.only(bottom: 12),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Title : ${widget.label.toString().split("|")[0]}",
                      style: GoogleFonts.philosopher(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        "Remind Time : ${widget.label.toString().split("|")[1]}",
                        style: GoogleFonts.philosopher(
                            textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ))),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Alert Level : ${widget.label.toString().split("|")[2]}%",
                      style: GoogleFonts.philosopher(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 22),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Current Battery : $batteryPercentage%",
                      style: GoogleFonts.philosopher(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Battery Status : ${batteryState}",
                      style: batteryState == BatteryState.discharging
                          ? GoogleFonts.philosopher(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  color: Colors.red),
                            )
                          : GoogleFonts.philosopher(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  color: Colors.green),
                            ),
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

  @override
  void dispose() {
    batteryStreamSubscription?.cancel();
    super.dispose();
  }
}
