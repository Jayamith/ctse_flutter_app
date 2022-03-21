import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Text('$_batteryState'),
      ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.battery_unknown),
      ),
    );
  }
  
  @override
  void dispose() {
    super.dispose();
    _battertyStateSubscription?.cancel();
  }
}
