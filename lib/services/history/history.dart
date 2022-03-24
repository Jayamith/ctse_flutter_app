import 'dart:async';

import 'package:ctse_app_life_saviour/db/db_helper.dart';
import 'package:ctse_app_life_saviour/models/historyModel.dart';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryHistory extends StatefulWidget {
  const BatteryHistory({Key? key}) : super(key: key);

  @override
  State<BatteryHistory> createState() => _BatteryHistoryState();
}

class _BatteryHistoryState extends State<BatteryHistory> {
  // const BatteryHistory({Key? key}) : super(key: key);
  final Battery _battery = Battery();

  BatteryState? _batteryState;
  List<History> _historyList = [];
  StreamSubscription<BatteryState>? _battertyStateSubscription;

  @override
  void initState() {
    super.initState();
    _refreshHistory();
    _battertyStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) async {
          setState(() {
            _batteryState = state;
          });
          // trigger
          if (state == BatteryState.charging) {
            await Future.delayed(Duration(seconds: 1));
            int tmpLevel = await _battery.batteryLevel;
            String tmpPluggedTime = DateTime.now().year.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().day.toString();
            History history = History(level: tmpLevel.toString(), pluggedTime: tmpPluggedTime);
            _saveLevel(history);
            _refreshHistory();
          } else {

          }
        });
  }

  _saveLevel(History history) async{
    await DBHelper.insertHistory(history);
  }

  _refreshHistory() async {
    List<History>? x = await DBHelper.fetchHistory();
    setState(() {
      _historyList = x!;
    });
  }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_list()],
        ),
      ),
    );
  }

  _list() => Expanded(
    child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.battery_charging_full_rounded,
                    color: Colors.blue,
                    size: 40.0,
                  ),
                  title: Text(
                    "${_historyList[index].level}",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "${_historyList[index].pluggedTime}"
                  ),
                ),
                Divider(
                  height: 5.0,
                )
              ],
            );
          },
          itemCount: _historyList.length,
        )),
  );

  @override
  void dispose() {
    super.dispose();
    _battertyStateSubscription?.cancel();
  }
}
