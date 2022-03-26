import 'dart:async';
import 'package:battery_info/enums/charging_status.dart';
import 'package:ctse_app_life_saviour/controllers/notifier_controller.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:ctse_app_life_saviour/services/notifier/add_notifier.dart';
import 'package:ctse_app_life_saviour/services/notifier/notifier_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/notifier_model.dart';
import 'single_notifier.dart';

class BatteryNotifier extends StatefulWidget {
  const BatteryNotifier({Key? key}) : super(key: key);

  @override
  State<BatteryNotifier> createState() => _BatteryNotifierState();
}

class _BatteryNotifierState extends State<BatteryNotifier> {
  final notifierController = Get.put(BatteryNotifierController());
  String batteryLevel = "";
  ChargingStatus chargingstatus = ChargingStatus.Discharging;
  var notificationHelper;

  @override
  void initState() {
    super.initState();
    notificationHelper = NotificationHelper();
    notificationHelper.initializeNotification();
    notificationHelper.requestIOSPermissions();

    AndroidBatteryInfo? infoandroid = AndroidBatteryInfo();

    Future.delayed(Duration.zero, () async {
      infoandroid = await BatteryInfoPlugin().androidBatteryInfo;

      batteryLevel = infoandroid!.batteryLevel.toString();
      chargingstatus = infoandroid!.chargingStatus!;
      setState(() {});
    });

    BatteryInfoPlugin()
        .androidBatteryInfoStream
        .listen((AndroidBatteryInfo? batteryInfo) {
      infoandroid = batteryInfo;
      batteryLevel = infoandroid!.batteryLevel.toString();
      chargingstatus = infoandroid!.chargingStatus!;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Battery Notifier",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
          color: chargingstatus == ChargingStatus.Charging ||
                  parseInt(batteryLevel) > 20
              ? Colors.green[800]
              : Colors.red[900],
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          height: 120,
          child: Column(
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),
              ),
              Text(
                "Battery Level: $batteryLevel %",
                style: const TextStyle(fontSize: 20),
              ),
              Text(chargingstatus.toString(),
                  style: const TextStyle(fontSize: 20)),
              displayNotifiers(),
            ],
          )
        ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addNotifier',
        onPressed: () async => {
          await Get.to(
            () => const AddNotifier(),
            transition: Transition.leftToRightWithFade,
          ),
          notifierController.getNotifier(),
        },
        child: const Icon(Icons.add_comment_rounded),
      ),
    );
  }


  displayNotifiers() {
    notifierController.getNotifier();
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: notifierController.notifierList.length,
          itemBuilder: (_, index) {
            Notifier notifier = notifierController.notifierList[index];
            if (parseInt(batteryLevel) <
                int.parse(notifier.level.toString()) && chargingstatus != ChargingStatus.Charging) {
              notificationHelper.scheduledNotification(
                  notifier
              );  
            }
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: notifierController.notifierList.length,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          displayBottomSheet(context, notifier);
                        },
                        child: SingleNoifier(notifier),
                      )
                    ],
                  ),
                )
              ));
          });
      }),
    );
  }

  displayBottomSheet(BuildContext context, notifier) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 5),
        height: notifier.isCompleted == 1
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
                color: Colors.red[400],
              ),
            ),
            const Spacer(),
            notifier.isCompleted == 1
              ? Container()
              : displayBottomSheetButton(
                  label: "Notifier Closed",
                  onTap: () {
                    notifierController.updateNotifier(notifier.id);
                    Get.back();
                  },
                  color: Colors.yellowAccent,
                  context: context),
            const SizedBox(
              height: 10,
            ),
            displayBottomSheetButton(
                label: "Delete Notifier",
                onTap: () {
                  notifierController.deleteNotifier(notifier);
                  Get.back();
                },
                color: Color.fromARGB(255, 196, 8, 8),
                context: context),
            const SizedBox(
              height: 20,
            ),
            displayBottomSheetButton(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                isClose: true,
                color: Colors.black,
                context: context), 
          ],
        ),
      ),
    );
  }

  displayBottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 50,
        width: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2, color: isClose == true ? Colors.redAccent[700]! : color),
          borderRadius: BorderRadius.circular(12),
          color: isClose == true ? Colors.transparent : color, 
        ),
        child: Center(
          child: Text(
            label,
            style: isClose == true
                ? GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.black
                  )
                )
                : GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.black)),
            ),
          ),
      ));
  }

  parseInt(String batteryLevel) {
    return parseInt(batteryLevel);
  }
}

