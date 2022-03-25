import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:ctse_app_life_saviour/controllers/reminder_controller.dart';
import 'package:ctse_app_life_saviour/services/reminder/add_reminder.dart';
import 'package:ctse_app_life_saviour/services/reminder/reminder_notification_service.dart';
import 'package:ctse_app_life_saviour/services/reminder/widgets/single_reminder.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/reminder_model.dart';

class BatteryReminder extends StatefulWidget {
  const BatteryReminder({Key? key}) : super(key: key);

  @override
  State<BatteryReminder> createState() => _BatteryReminderState();
}

class _BatteryReminderState extends State<BatteryReminder> {
  final Battery battery = Battery();
  int batteryPercentage = 100;
  late Timer timer;
  var notificationHelper;
  DateTime _selectedDate = DateTime.now();
  final _reminderController = Get.put(BatteryReminderController());

  @override
  void initState() {
    super.initState();
    listenBatteryLevel();
    notificationHelper = NotificationHelper();
    notificationHelper.initializeNotification();
    notificationHelper.requestIOSPermissions();
  }

  void listenBatteryLevel() {
    updateBatteryLevel();
    /*timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async => updateBatteryLevel(),
    );*/
  }

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
        title: const Center(
          child: Text(
            "Reminder Scheduler",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _displayToday(),
          _displayDateSelector(),
          const SizedBox(
            height: 10,
          ),
          _displayReminders()
        ],
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: 'addReminder',
          onPressed: () async => {
                await Get.to(
                  () => const AddReminder(),
                  transition: Transition.leftToRightWithFade,
                  //duration: const Duration(seconds: 1)
                ),
                _reminderController.getReminders(),
              },
          child: const Icon(Icons.notification_add)),
    );
  }

  _displayToday() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: GoogleFonts.bebasNeue(
                    textStyle: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w400)),
              ),
              Text(
                "Today",
                style: GoogleFonts.cinzel(
                    textStyle: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ],
    );
  }

  _displayDateSelector() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 60,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.blue,
        dayTextStyle: GoogleFonts.cinzel(
            textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        )),
        monthTextStyle: GoogleFonts.neuton(
            textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        )),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _displayReminders() {
    _reminderController.getReminders();
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _reminderController.reminderList.length,
            itemBuilder: (_, index) {
              Reminder reminder = _reminderController.reminderList[index];
              //print(reminder.toJson());
              if (reminder.repeat == 'Daily') {
                DateTime date =
                    DateFormat.jm().parse(reminder.startTime.toString());
                var formattedTime = DateFormat("HH:mm").format(date);
                //print(formattedTime);
                if (batteryPercentage <
                    int.parse(reminder.remindMe.toString())) {
                  notificationHelper.scheduledNotification(
                      int.parse(formattedTime.toString().split(":")[0]),
                      int.parse(formattedTime.toString().split(":")[1]),
                      reminder);
                }
                return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: _reminderController.reminderList.length,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _displayBottomSheet(context, reminder);
                              },
                              child: SingleReminder(reminder),
                            )
                          ],
                        ),
                      ),
                    ));
              }
              if (reminder.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: _reminderController.reminderList.length,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _displayBottomSheet(context, reminder);
                              },
                              child: SingleReminder(reminder),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container();
              }
            });
      }),
    );
  }

  _displayBottomSheet(BuildContext context, reminder) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 5),
        height: reminder.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.25
            : MediaQuery.of(context).size.height * 0.35,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 8,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[400],
              ),
            ),
            const Spacer(),
            reminder.isCompleted == 1
                ? Container()
                : _displayBottomSheetButton(
                    label: "Reminder Completed",
                    onTap: () {
                      _reminderController.updateStatus(reminder.id);
                      Get.back();
                    },
                    colr: Colors.blue,
                    context: context),
            const SizedBox(
              height: 10,
            ),
            _displayBottomSheetButton(
                label: "Delete Reminder",
                onTap: () {
                  _reminderController.delete(reminder);
                  Get.back();
                },
                colr: Colors.red,
                context: context),
            const SizedBox(
              height: 20,
            ),
            _displayBottomSheetButton(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                isClose: true,
                colr: Colors.red,
                context: context),
          ],
        ),
      ),
    );
  }

  _displayBottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color colr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: isClose == true ? Colors.grey[600]! : colr),
            borderRadius: BorderRadius.circular(12),
            color: isClose == true ? Colors.transparent : colr,
          ),
          child: Center(
            child: Text(
              label,
              style: isClose == true
                  ? GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: Colors.black))
                  : GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: Colors.white)),
            ),
          ),
        ));
  }

  /*@override
  void dispose() {
    timer.cancel();
    super.dispose();
  }*/
}
