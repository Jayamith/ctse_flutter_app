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
  TextEditingController descriptionController = TextEditingController();
  BatteryReminderController reminderController =
      Get.put(BatteryReminderController());
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "12:00 AM";
  int _remindTime = 5;
  List<int> remindList = [5, 10, 15, 20, 25, 30];
  String _repeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Reminder",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.cyanAccent,
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(titleController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
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
              InputField(
                title: "Description",
                hint: "Enter your description",
                controller: descriptionController,
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
              Row(
                children: [
                  Expanded(
                      child: InputField(
                    hint: _startTime,
                    title: 'Start Time',
                    widget: IconButton(
                      onPressed: () {
                        _getSelectedTime(isStartTime: true);
                      },
                      icon: const Icon(Icons.access_time_outlined),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: InputField(
                    hint: _endTime,
                    title: 'End Time',
                    widget: IconButton(
                      onPressed: () {
                        _getSelectedTime(isStartTime: false);
                      },
                      icon: const Icon(Icons.access_time_outlined),
                    ),
                  ))
                ],
              ),
              InputField(
                title: "Remind Me",
                hint: "$_remindTime minutes early",
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
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                        value: value.toString(), child: Text(value.toString()));
                  }).toList(),
                ),
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
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      //Save Data
      _saveDataToDB();
      Get.back();
    } else if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue[50],
          colorText: Colors.red,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
          ));
    }
  }

  _saveDataToDB() async {
    int value = await reminderController.addReminder(
        reminder: Reminder(
      title: titleController.text,
      description: descriptionController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
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
