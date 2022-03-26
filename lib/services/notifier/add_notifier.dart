import 'package:ctse_app_life_saviour/controllers/notifier_controller.dart';
import 'package:ctse_app_life_saviour/services/notifier/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/notifier_model.dart';

class AddNotifier extends StatefulWidget {
  const AddNotifier({Key? key}) : super(key: key);

  @override
  State<AddNotifier> createState() => _AddNotifierState();
}

class _AddNotifierState extends State<AddNotifier> {
  BatteryNotifierController notifierController =
      Get.put(BatteryNotifierController());
  int batteryLevel = 20;
  List<int> levelsList = [5, 10, 15, 20, 25, 30];
  String _repeat = "Once";
  List<String> repeatList = ["Once", "Daily"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Notifier",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Battery Level",
                      hint: "$batteryLevel%",
                      widget: DropdownButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 32,
                        elevation: 6,
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            batteryLevel = int.parse(newValue!);
                          });
                        },
                        items: levelsList
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
                          Icons.battery_alert,
                          color: Colors.red,
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
                    _saveDataToDB();
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

  _saveDataToDB() async {
    int value = await notifierController.addNotifier(
        notifier: Notifier(
      level: batteryLevel,
      repeat: _repeat,
      isCompleted: 0,
    ));
    print("My ID is " + "$value");
  }
}
