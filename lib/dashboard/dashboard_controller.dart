import 'package:get/get.dart';

class DashBoardController extends GetxController {
  var selectedTab = 0;
  void changeTab(int index) {
    selectedTab = index;
    update();
  }
}
