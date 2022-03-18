import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard/dashboard.dart';
import 'dashboard/dashboard_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Life Saviour',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => const DashBoard(),
          binding: BindingDashBoard(),
        )
      ],
    );
  }
}
