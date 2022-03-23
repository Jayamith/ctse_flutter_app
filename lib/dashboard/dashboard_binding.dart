import 'package:get/get.dart';

import '../services/history/history_controller.dart';
import '../controllers/notifier_controller.dart';
import '../services/optimizer/optimizer_controller.dart';
import '../controllers/reminder_controller.dart';
import 'dashboard_controller.dart';

class BindingDashBoard extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashBoardController>(() => DashBoardController());
    Get.lazyPut<BatteryNotifierController>(() => BatteryNotifierController());
    Get.lazyPut<BatteryReminderController>(() => BatteryReminderController(),
        fenix: true);
    Get.lazyPut<BatteryOptimizerController>(() => BatteryOptimizerController());
    Get.lazyPut<BatteryHistoryController>(() => BatteryHistoryController());
  }
}
