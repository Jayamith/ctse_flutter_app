import 'package:ctse_app_life_saviour/db/db_helper.dart';
import 'package:ctse_app_life_saviour/models/reminder_model.dart';
import 'package:get/get.dart';

class BatteryReminderController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var reminderList = <Reminder>[].obs;

  Future<int> addReminder({Reminder? reminder}) async {
    return await DBHelper.insert(reminder);
  }

  void getReminders() async {
    List<Map<String, dynamic>> reminders = await DBHelper.getData();
    reminderList
        .assignAll(reminders.map((data) => Reminder.fromJson(data)).toList());
  }

  void delete(Reminder reminder) {
    DBHelper.delete(reminder);
  }
}
