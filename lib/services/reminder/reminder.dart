import 'package:ctse_app_life_saviour/controllers/reminder_controller.dart';
import 'package:ctse_app_life_saviour/services/reminder/add_reminder.dart';
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
          const SizedBox(
            height: 10,
          ),
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
              print(reminder.toJson());
              if (reminder.repeat == 'Daily') {
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
}
