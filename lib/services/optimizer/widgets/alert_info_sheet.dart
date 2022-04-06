import 'dart:io';

import 'package:ctse_app_life_saviour/services/optimizer/optimizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ctse_app_life_saviour/constants/platform_constants.dart';
import 'package:ctse_app_life_saviour/constants/task_constants.dart';
import 'package:ctse_app_life_saviour/provider/app_usage_provider.dart';
import 'package:ctse_app_life_saviour/services/optimizer/homeOptimizer.dart';
import 'package:workmanager/workmanager.dart';

class AlertInfoSheet extends StatefulWidget {
  final Function popContext;
  const AlertInfoSheet(this.popContext, {Key? key}) : super(key: key);

  @override
  _AlertInfoSheetState createState() => _AlertInfoSheetState();
}

class _AlertInfoSheetState extends State<AlertInfoSheet> {
  TextEditingController limitController = new TextEditingController();
  TextEditingController appController = new TextEditingController();
  FocusNode limitFN = new FocusNode();
  late AppUsageInfoProvider appUsageInfoProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    appUsageInfoProvider =
        Provider.of<AppUsageInfoProvider>(context, listen: false);

    appUsageInfoProvider.setAppNamesList();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: Key('upcoming_event_detailed'),
      children: [
        SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.2,
              ),
              child: Container(
                // decoration: BoxDecoration(
                //     gradient: RadialGradient(
                //   center: Alignment(1, -1.5),
                //   focal: Alignment(1, -1),
                //   focalRadius: 1.0,
                //   colors: [Colors.blue, Colors.white],
                // )),
                padding: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        TextField(
                          enabled: false,
                          controller: appController,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          onChanged: (value) async {},
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: DropdownButton<String>(
                            items:
                            appUsageInfoProvider.appsNames.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              appController.text = value.toString();
                            },
                          ),
                        ),
                      ],
                    ),
                    TextField(
                        controller: limitController,
                        focusNode: limitFN,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.04,
                              left: MediaQuery.of(context).size.width * 0.02),
                          hintText: "Please Enter a Time Limit",
                        )),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: PlatformEnabledButton(
                          platform: PlatformConstants.ANDROID,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Confirm"),
                              Icon(Icons.check),
                            ],
                          ),
                          onPressed: () {
                            if (limitController.text.isNotEmpty &&
                                appController.text.isNotEmpty) {
                              var appData = new Map<String, dynamic>();
                              appData["appName"] = appController.text;
                              appData["limit"] = int.parse(limitController.text);

                              Workmanager().registerPeriodicTask(
                                "3",
                                TaskConstants.SET_USAGE_ALERTS,
                                inputData: appData,
                                initialDelay: Duration(seconds: 2),
                                frequency: Duration(minutes: 15),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
