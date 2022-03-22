import 'dart:async';
import 'package:ctse_app_life_saviour/controllers/notifier_controller.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BatteryNotifier extends StatefulWidget {
  const BatteryNotifier({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BatteryNotifierState createState() => _BatteryNotifierState();
}

class _BatteryNotifierState extends State<BatteryNotifier> {
  final Battery _battery = Battery();

  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _battertyStateSubscription;

  @override
  void initState() {
    super.initState();
    _battertyStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
    });
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
      body: Column(children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 110, vertical: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMd().format(DateTime.now()),
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        '$_batteryState',
                        style: GoogleFonts.ubuntu(
                            textStyle: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
                      )),
                ],
              ),
            )
          ],
        )
      ]),
      floatingActionButton: FloatingActionButton(
        //onPressed: () => Get.to(const AddReminder()),
        onPressed: () async {
          final batteryLevel = await _battery.batteryLevel;

          showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              content: Text('Battery: $batteryLevel%'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.add_comment_rounded),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _battertyStateSubscription?.cancel();
  }
}
