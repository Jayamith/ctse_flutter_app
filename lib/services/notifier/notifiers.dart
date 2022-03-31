import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

import 'package:ctse_app_life_saviour/db/db_helper.dart';
import 'package:ctse_app_life_saviour/models/notifier_model.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BatteryNotifier extends StatefulWidget {
  const BatteryNotifier({Key? key}) : super(key: key);

  @override
  State<BatteryNotifier> createState() => _BatteryNotifierState();
}

class _BatteryNotifierState extends State<BatteryNotifier> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final Battery _battery = Battery();
  BatteryState? _batteryState;
  List<Notifier> _notifierList = [];
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    _refreshNotifier();

    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) async {
      setState(() {
        _batteryState = state;
      });
      if (state == BatteryState.discharging) {
        int currentLevel = await _battery.batteryLevel;
        if (currentLevel < 20) {
          bool isallowed = await AwesomeNotifications().isNotificationAllowed();
          if (!isallowed) {
            //no permission of local notification
            AwesomeNotifications().requestPermissionToSendNotifications();
          } else {
            //show notification
            AwesomeNotifications().createNotification(
                content: NotificationContent(
              //simple notification
              id: 123,
              channelKey: 'basic', //set configuration wuth key "basic"
              title: 'Battery is Lower than 20%',
              body:
                  'Your Battery level is $currentLevel%. Please Connect your charger',
            ));
          }
          Notifier notifier = Notifier(level: currentLevel.toString());
          _saveNotifier(notifier);
          _refreshNotifier();
        }
      } else {}
    });
  }

  _saveNotifier(Notifier notifier) async {
    await DBHelper.insertNotifier(notifier);
  }

  _refreshNotifier() async {
    List<Notifier>? notifiers = await DBHelper.fetchNotifier();
    setState(() {
      _notifierList = notifiers!;
    });
  }

  _clearAll() async {
    await DBHelper.deleteAllNotifiers();
    _refreshNotifier();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_list(), _button()],
        ),
      ),
    );
  }

  _button() => Container(
        color: Colors.grey,
        margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Form(
          child: Column(
            children: <Widget>[
              Container(
                  child: ButtonTheme(
                minWidth: double.infinity,
                child: RaisedButton(
                  onPressed: () => _clearAll(),
                  child: const Text('Delete All'),
                  color: Colors.redAccent,
                  textColor: Colors.yellowAccent,
                ),
              ))
            ],
          ),
        ),
      );

  _list() => Expanded(
        child: Card(
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.add_comment_rounded,
                        color: Colors.red[400],
                        size: 40.0,
                      ),
                      title: const Text(
                        "Battery Level is lower than 20%. Connect your charger",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${_notifierList[index].level}%"),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_sweep,
                          color: Colors.red[900],
                        ),
                        onPressed: () async {
                          await DBHelper.deleteNotifier(
                              _notifierList[index].id);
                          _refreshNotifier();
                        },
                      ),
                    ),
                    const Divider(
                      height: 5.0,
                    )
                  ],
                );
              },
              itemCount: _notifierList.length,
            )),
      );

  @override
  void dispose() {
    super.dispose();
    _batteryStateSubscription?.cancel();
  }
}
