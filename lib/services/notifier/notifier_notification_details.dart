import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:battery_plus/battery_plus.dart';

class NotificationDetail extends StatefulWidget {
  final String? label;
  const NotificationDetail({Key? key, required this.label}) : super(key: key);

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  final Battery battery = Battery();
  int batteryLevel = 100;
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
    final Level = await battery.batteryLevel;
    setState(() {
      batteryLevel = Level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Connect Your Charger",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
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
                      "Alert Level : ${widget.label.toString().split("|")[0]}%",
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
                      "Current Battery : $batteryLevel%",
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
                      "Battery Status : $batteryState",
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
