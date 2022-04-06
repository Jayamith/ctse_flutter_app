import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../navigation_bar/custom_navigation_bar.dart';
import '../services/history/history.dart';
import '../services/notifier/notifiers.dart';
import '../services/optimizer/optimizer.dart';
import '../services/reminder/reminder.dart';
import 'dashboard_controller.dart';

class DashBoard extends StatefulWidget {
  final Function callbackDispatcher;
  const DashBoard(this.callbackDispatcher, {Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _inactiveColor = Colors.blueGrey;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: controller.selectedTab,
            children: [
              BatteryNotifier(),
              BatteryReminder(),
              DefaultBottomBarController(
                  child: BatteryOptimizer(widget.callbackDispatcher)),
              BatteryHistory(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          containerHeight: 70,
          backgroundColor: Colors.white,
          selectedIndex: controller.selectedTab,
          showElevation: true,
          itemCornerRadius: 26,
          curve: Curves.easeInSine,
          onItemSelected: controller.changeTab,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: const Icon(Icons.battery_alert),
              title: const Text('Notifier'),
              activeColor: Colors.red,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.notification_add),
              title: const Text('Reminder'),
              activeColor: Colors.blue,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.settings_brightness),
              title: const Text('Optimizer'),
              activeColor: Colors.blue,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.history),
              title: const Text('History'),
              activeColor: Colors.purple,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });
  }
}
