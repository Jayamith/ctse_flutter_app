import 'dart:io';

import 'package:ctse_app_life_saviour/constants/platform_constants.dart';
import 'package:ctse_app_life_saviour/provider/app_usage_provider.dart';
import 'package:ctse_app_life_saviour/services/optimizer/optimizer_setup.dart';
import 'package:ctse_app_life_saviour/services/optimizer/widgets/alert_info_sheet.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class BatteryOptimizer extends StatefulWidget {
  final Function callbackDispatcher;

  BatteryOptimizer(this.callbackDispatcher);

  @override
  _BatteryOptimizerState createState() => _BatteryOptimizerState();
}

class _BatteryOptimizerState extends State<BatteryOptimizer> {
  bool isLoading = false;
  late AppUsageInfoProvider appUsageInfoProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeWorkManager();
  }

  Future<void> initializeWorkManager() async {
    await Workmanager().initialize(
      widget.callbackDispatcher,
      isInDebugMode: true,
    );
    setState(() {
      isLoading = true;
    });
    await appUsageInfoProvider.getAppUsageInfo();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    appUsageInfoProvider =
        Provider.of<AppUsageInfoProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Battery Optimizer",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Column(
            children: [
              Container(
                height: height * 0.7,
                child: (!isLoading &&
                        appUsageInfoProvider.appUsageInfoList.isEmpty)
                    ? Center(
                        child: Text("No app usage information found"),
                      )
                    : isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount:
                                appUsageInfoProvider.appUsageInfoList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Image.memory(appUsageInfoProvider
                                      .appUsageInfoList[index].icon),
                                ),
                                title: Text(appUsageInfoProvider
                                    .appUsageInfoList[index].name),
                                trailing: Text(appUsageInfoProvider.getDuration(
                                    appUsageInfoProvider
                                        .appUsageInfoList[index].usage)),
                              );
                            }),
              ),
              // Container(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       ElevatedButton(
              //           //platform: _Platform.android,
              //           child: Text("Register Periodic Task"),
              //           onPressed: () {
              //             alertBottomSheet(context);
              //           }),
              //       PlatformEnabledButton(
              //         platform: PlatformConstants.ANDROID,
              //         child: Text("Cancel All"),
              //         onPressed: () async {
              //           await Workmanager().cancelAll();
              //           print('Cancel all tasks completed');
              //         },
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onVerticalDragUpdate: DefaultBottomBarController.of(context).onDrag,
        onVerticalDragEnd: DefaultBottomBarController.of(context).onDragEnd,
        child: FloatingActionButton.extended(
          label: AnimatedBuilder(
            animation: DefaultBottomBarController.of(context).state,
            builder: (context, child) => Row(
              children: [
                Text(
                  DefaultBottomBarController.of(context).isOpen
                      ? "Set Periodic Task"
                      : "Set Periodic Task",
                ),
                const SizedBox(width: 4.0),
                AnimatedBuilder(
                  animation: DefaultBottomBarController.of(context).state,
                  builder: (context, child) => Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.diagonal3Values(
                      1,
                      DefaultBottomBarController.of(context).state.value * 2 -
                          1,
                      1,
                    ),
                    child: child,
                  ),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.chevron_right,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          elevation: 2,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          //
          //Set onPressed event to swap state of bottom bar
          onPressed: () => DefaultBottomBarController.of(context).swap(),
        ),
      ),

      // Actual expandable bottom bar
      bottomNavigationBar: BottomExpandableAppBar(
        horizontalMargin: 16,
        appBarHeight: 5,
        notchMargin: 20,

        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
        expandedBackColor: Theme.of(context).backgroundColor,
        expandedBody: OptimizerSetup(),
        // bottomAppBarBody: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.max,
        //     children: <Widget>[
        //       Expanded(
        //         child: Text(
        //           "Foo",
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //       Spacer(
        //         flex: 2,
        //       ),
        //       Expanded(
        //         child: Text(
        //           "Bar",
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     setState(() {
      //       isLoading = true;
      //     });
      //     await appUsageInfoProvider.getAppUsageInfo();
      //     setState(() {
      //       isLoading = false;
      //     });
      //   },
      //   child: Icon(Icons.refresh),
      // ),
    );
  }
}

void alertBottomSheet(context) {
  showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            StatefulBuilder(builder: (BuildContext context, updateState) {
              return AlertInfoSheet(closeBottomSheet);
            })
          ],
        );
      });
}

void closeBottomSheet(BuildContext context) {
  Navigator.pop(context);
}

class PlatformEnabledButton extends ElevatedButton {
  final String platform;

  PlatformEnabledButton({
    required this.platform,
    required Widget child,
    required VoidCallback onPressed,
  }) : super(
            child: child,
            onPressed:
                (Platform.isAndroid && platform == PlatformConstants.ANDROID ||
                        Platform.isIOS && platform == PlatformConstants.IOS)
                    ? onPressed
                    : null);
}
