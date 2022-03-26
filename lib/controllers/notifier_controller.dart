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
    return await DBHelper.insertNotifier(notifier);
  }

  void getNotifiers() async {
    List<Map<String, dynamic>> notifiers = await DBHelper.getNotifiers();
    notifierList
        .assignAll(notifiers.map((data) => Notifier.fromJson(data)).toList());
  }

  void updateNotifier(int id) async {
    await DBHelper.updateNotifier(id);
    getNotifiers();
  }

  void deleteNotifier(Notifier notifier) {
    DBHelper.deleteNotifier(notifier);
    getNotifiers();
  }
}
