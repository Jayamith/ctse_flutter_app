import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ctse_app_life_saviour/db/db_helper.dart';
import 'package:ctse_app_life_saviour/models/appModel.dart';
import 'package:ctse_app_life_saviour/provider/app_usage_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OptimizerSetup extends StatefulWidget {
  const OptimizerSetup({Key? key}) : super(key: key);

  @override
  State<OptimizerSetup> createState() => _OptimizerSetupState();
}

class _OptimizerSetupState extends State<OptimizerSetup> {
  final TextEditingController _appController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  late AppUsageInfoProvider appUsageInfoProvider;
  String _startTime = DateFormat("hh:mm")
      .format(DateTime.parse("1969-07-20 00:00:04"))
      .toString();
  String _endTime = "12:00 AM";
  bool isLoading = false;
  int selectedReminder = -1;
  bool isUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getAppUsageInfo();
    });
  }

  Future<void> getAppUsageInfo() async {
    await appUsageInfoProvider.getAppUsageInfo();
    appUsageInfoProvider.setAppNamesList();
    setState(() {
      isLoading = true;
    });
    await appUsageInfoProvider.getSavedAppReminders();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> insertApps(App? app) async {
    await DBHelper.insertApp(app);

      bool isallowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isallowed) {
        //no permission of local notification
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        await AwesomeNotifications().createNotification(
            content: NotificationContent(
              //simple notification
              id: 125,
              channelKey: 'basic', //set configuration wuth key "basic"
              title: 'Excessive Usage Warning',
              body: 'You have used Youtube for 10 minutes',
            ));
      }
  }

  @override
  Widget build(BuildContext context) {
    appUsageInfoProvider =
        Provider.of<AppUsageInfoProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
      height: height,
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: (!isLoading &&
                      appUsageInfoProvider.appRemindersList.isNotEmpty)
                  ? ListView.builder(
                      itemCount: appUsageInfoProvider.appRemindersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return usageItem(
                            appUsageInfoProvider.appRemindersList[index]);
                      })
                  : isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Center(
                          child: Text("No reminders to show",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
            ),
          ),
          const Divider(),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      TextField(
                        enabled: false,
                        controller: _appController,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        onChanged: (value) async {},
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: (isUpdate &&
                                appUsageInfoProvider
                                    .appRemindersList.isNotEmpty &&
                                selectedReminder >= 0 &&
                                appUsageInfoProvider
                                        .appRemindersList[selectedReminder]
                                        .id !=
                                    null)
                            ? const Icon(Icons.keyboard_arrow_down_sharp)
                            : DropdownButton<String>(
                                items: appUsageInfoProvider.appsNames
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  _appController.text = value.toString();
                                },
                              ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      TextField(
                        enabled: false,
                        controller: _durationController,
                      ),
                      GestureDetector(
                          onTap: () async {
                            await _getSelectedTime(isStartTime: true);
                          },
                          child: const Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(Icons.lock_clock)))
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isUpdate
                              ? GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isUpdate = false;
                                      _appController.text = "";
                                      _durationController.text = "";
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: const Text(
                                      "Reset",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.zero,
                                ),
                          const Padding(
                            padding: EdgeInsets.only(right: 5),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_appController.text.isNotEmpty &&
                                  _durationController.text.isNotEmpty) {
                                App app = App();
                                app.appName = _appController.text.toString();
                                app.duration =
                                    _durationController.text.toString();
                                if ((isUpdate &&
                                    appUsageInfoProvider
                                        .appRemindersList.isNotEmpty &&
                                    selectedReminder >= 0 &&
                                    appUsageInfoProvider
                                            .appRemindersList[selectedReminder]
                                            .id !=
                                        null)) {
                                  await DBHelper.updateApp(
                                      app.id, app.duration);
                                } else {
                                  await DBHelper.insertApp(app);
                                }
                                setState(() {
                                  isLoading = true;
                                });
                                await getAppUsageInfo();
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                (isUpdate &&
                                        appUsageInfoProvider
                                            .appRemindersList.isNotEmpty &&
                                        selectedReminder >= 0 &&
                                        appUsageInfoProvider
                                                .appRemindersList[
                                                    selectedReminder]
                                                .id !=
                                            null)
                                    ? "Update"
                                    : "Add",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _getSelectedTime({required bool isStartTime}) async {
    var clickedTime = await _displayTimePicker();
    String _formattedTime = clickedTime.format(context);
    if (clickedTime == null) {
      print("Not Selected");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
        _durationController.text = _startTime.toString();
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

  Widget usageItem(App app) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Text(app.appName.toString()),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                  Text(app.duration.toString()),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _appController.text = app.appName.toString();
                        _durationController.text = app.duration.toString();

                        String hours = app.duration!.split(":")[0];
                        String minutes = app.duration!.split(":")[1];

                        DateTime dateTime =
                            DateTime.parse("1969-07-20 $hours:$minutes:04");
                        _startTime =
                            DateFormat("hh:mm").format(dateTime).toString();
                        selectedReminder =
                            appUsageInfoProvider.appRemindersList.indexOf(app);
                        isUpdate = true;
                      });
                    },
                    child: Container(
                      height: height * 0.055,
                      width: width * 0.10,
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: const Center(
                          child: Icon(
                        Icons.edit,
                        size: 15,
                      )),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await DBHelper.deleteApp(app.id!);
                      await getAppUsageInfo();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      height: height * 0.055,
                      width: width * 0.10,
                      child: const Center(
                          child: Icon(
                        Icons.delete,
                        size: 15,
                      )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
