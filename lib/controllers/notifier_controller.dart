import 'package:get/get.dart';
import 'package:ctse_app_life_saviour/db/db_helper.dart';
import 'package:ctse_app_life_saviour/models/notifier_model.dart';

class BatteryNotifierController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var notifierList = <Notifier>[].obs;

  Future<int> addNotifier({Notifier? notifier}) async {
    return await DBHelper.insert(notifier);
  }
}
