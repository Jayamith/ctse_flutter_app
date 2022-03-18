import 'package:ctse_app_life_saviour/services/reminder/add_reminder.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
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
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 110),
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
          ),
          Container(
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const AddReminder()),
      ),
    );
  }
}
