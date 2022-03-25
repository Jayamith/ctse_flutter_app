import 'package:ctse_app_life_saviour/controllers/notifier_controller.dart';
import 'package:ctse_app_life_saviour/services/notifier/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/notifier_model.dart';

class AddNotifier extends StatefulWidget {
  const AddNotifier({Key? key}) : super(key: key);

  @override
  State<AddNotifier> createState() => _AddNotifierState();
}

class _AddNotifierState extends State<AddNotifier> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  BatteryNotifierController notifierController =
      Get.put(BatteryNotifierController());
  int _remindTime = 5;
  List<int> remindList = [5, 10, 15, 20, 25, 30];
  String _repeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Notifier",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.cyanAccent,
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
}
