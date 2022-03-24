import 'dart:async';
import 'package:battery_info/enums/charging_status.dart';
import 'package:ctse_app_life_saviour/controllers/notifier_controller.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BatteryNotifier extends StatefulWidget {
  const BatteryNotifier({Key? key}) : super(key: key);

  @override
  _BatteryNotifierState createState() => _BatteryNotifierState();
}

class _BatteryNotifierState extends State<BatteryNotifier> {
  String batteryLevel = "";
  ChargingStatus chargingstatus = ChargingStatus.Discharging;

  @override
  void initState() {
    AndroidBatteryInfo? infoandroid = AndroidBatteryInfo();

    Future.delayed(Duration.zero, () async {
      infoandroid = await BatteryInfoPlugin().androidBatteryInfo;

      batteryLevel = infoandroid!.batteryLevel.toString();
      chargingstatus = infoandroid!.chargingStatus!;
      setState(() {});
    });

    BatteryInfoPlugin()
        .androidBatteryInfoStream
        .listen((AndroidBatteryInfo? batteryInfo) {
      infoandroid = batteryInfo;
      batteryLevel = infoandroid!.batteryLevel.toString();
      chargingstatus = infoandroid!.chargingStatus!;
      setState(() {});
    });
    super.initState();
  }

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
      body: Container(
          color: chargingstatus == ChargingStatus.Charging ||
                  parseInt(batteryLevel) > 20
              ? Color.fromARGB(255, 3, 145, 10)
              : Color.fromARGB(255, 243, 45, 45),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          height: 120,
          child: Column(
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),
              ),
              Text(
                "Battery Level: $batteryLevel %",
                style: const TextStyle(fontSize: 20),
              ),
              Text(chargingstatus.toString(),
                  style: const TextStyle(fontSize: 20)),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => {
          await Get.to(() => const AddReminder()),
        },
        child: const Icon(Icons.add_comment_rounded),
      ),
    );
  }
}

parseInt(String batteryLevel) {
  return int.parse(batteryLevel);
}
