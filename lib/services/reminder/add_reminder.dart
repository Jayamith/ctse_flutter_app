import 'package:ctse_app_life_saviour/controllers/reminder_controller.dart';
import 'package:ctse_app_life_saviour/services/reminder/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/reminder_model.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({Key? key}) : super(key: key);

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  TextEditingController titleController = TextEditingController();
  BatteryReminderController reminderController =
      Get.put(BatteryReminderController());
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "12:00 AM";
  int _remindTime = 50;
  List<int> remindList = [5, 10, 25, 50, 75, 90];
  String _repeat = "Once";
  List<String> repeatList = ["Once", "Daily"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Reminder",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                title: "Title",
                hint: "Enter your title",
                controller: titleController,
              ),
              const SizedBox(
                height: 10,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getSelectedDate();
                  },
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: InputField(
                    hint: _startTime,
                    title: 'Remind Time',
                    widget: IconButton(
                      onPressed: () {
                        _getSelectedTime(isStartTime: true);
                      },
                      icon: const Icon(Icons.access_time_outlined),
                    ),
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 45),
                      child: GestureDetector(
                        onTap: () {
                          Get.defaultDialog(
                            radius: 20.0,
                            title: "Reminder Time Info",
                            middleText: "You Will Be Notified At This Time!",
                            textConfirm: "Okay",
                            confirm: OutlinedButton.icon(
                              onPressed: () => Get.back(),
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              label: const Text(
                                "Okay",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.notification_important,
                          color: Colors.blue,
                          size: 45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Remind Me",
                      hint: "$_remindTime" + "%",
                      widget: DropdownButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 32,
                        elevation: 6,
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _remindTime = int.parse(newValue!);
                          });
                        },
                        items: remindList
                            .map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Text(value.toString()));
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 45),
                      child: GestureDetector(
                        onTap: () {
                          Get.defaultDialog(
                            radius: 10.0,
                            title: "Battery Level Info",
                            middleText:
                                "You Will Be Notified If Battery Level Is Lower Than This!",
                            textConfirm: "Okay",
                            confirm: OutlinedButton.icon(
                              onPressed: () => Get.back(),
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              label: const Text(
                                "Okay",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.battery_charging_full,
                          color: Colors.blue,
                          size: 45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InputField(
                title: "Repeat",
                hint: _repeat,
                widget: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 32,
                  elevation: 6,
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _repeat = (newValue!);
                    });
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value!));
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _validateData();
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (titleController.text.isNotEmpty) {
      //Save Data
      _saveDataToDB();
      Get.back();
    } else if (titleController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue[50],
          colorText: Colors.red,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _saveDataToDB() async {
    int value = await reminderController.addReminder(
        reminder: Reminder(
      title: titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      remindMe: _remindTime,
      repeat: _repeat,
      isCompleted: 0,
    ));
    print("My ID is " + "$value");
  }

  _getSelectedDate() async {
    DateTime? _clickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2026));

    setState(() {
      _selectedDate = _clickedDate!;
    });
  }

  _getSelectedTime({required bool isStartTime}) async {
    var clickedTime = await _displayTimePicker();
    String _formattedTime = clickedTime.format(context);
    if (clickedTime == null) {
      print("Not Selected");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _displayTimePicker() {
    return showTimePicker(
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
        context: context,
        initialEntryMode: TimePickerEntryMode.input);
  }
}
