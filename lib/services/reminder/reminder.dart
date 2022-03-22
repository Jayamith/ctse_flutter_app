import 'package:ctse_app_life_saviour/controllers/reminder_controller.dart';
import 'package:ctse_app_life_saviour/services/reminder/add_reminder.dart';
import 'package:ctse_app_life_saviour/services/reminder/widgets/single_reminder.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BatteryReminder extends StatefulWidget {
  const BatteryReminder({Key? key}) : super(key: key);

  @override
  State<BatteryReminder> createState() => _BatteryReminderState();
}

class _BatteryReminderState extends State<BatteryReminder> {
  DateTime _selectedDate = DateTime.now();
  final _reminderController = Get.put(BatteryReminderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Battery Reminder",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.cyanAccent,
      ),
      body: Column(
        children: [
          _displayToday(),
          _displayDateSelector(),
          _displayReminders()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => {
          await Get.to(() => const AddReminder()),
          _reminderController.getReminders(),
        },
      ),
    );
  }

  _displayToday() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 100),
          child: Column(
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: GoogleFonts.pacifico(
                    textStyle: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              Text(
                "Today",
                style: GoogleFonts.pacifico(
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        )
      ],
    );
  }

  _displayDateSelector() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 60,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.teal,
        dayTextStyle: GoogleFonts.aladin(
            textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        )),
        monthTextStyle: GoogleFonts.aBeeZee(
            textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        )),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  _displayReminders() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _reminderController.reminderList.length,
            itemBuilder: (_, index) {
              print(_reminderController.reminderList.length);

              return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: _reminderController.reminderList.length,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _displayBottomSheet(context,
                                  _reminderController.reminderList[index]);
                            },
                            child: SingleReminder(
                                _reminderController.reminderList[index]),
                          )
                        ],
                      ),
                    ),
                  ));
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
      ),
    );
  }
}
