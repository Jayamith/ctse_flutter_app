import 'package:app_usage/app_usage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:ctse_app_life_saviour/models/optimizerModel.dart';

class AppUsageService {
  List appUsageInfoList = [];
  List<AppInfo> appInfo = [];
  List<String> appsNames = [];
  bool isExcessUsage = false;

  Future<List> getUsageStats() async {
    try {
      DateTime endDate = new DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
      await AppUsage.getAppUsage(startDate, endDate);
      List<AppInfo> installed = [];
      installed = await getAllInstalledApps();

      List<Optimizer> showApps = [];
      var icon;
      var name;
      var usage;

      for(var app in installed) {
        for(int i = 0; i < infoList.length; i++) {
          if(app.name.toString().toLowerCase() == infoList[i].appName.toString().toLowerCase()){
            Optimizer optimizer = new Optimizer();
            optimizer.name = app.name;
            optimizer.usage = infoList[i].usage;
            optimizer.icon = app.icon;
            showApps.add(optimizer);
            break;
          }}
      }

      print("ssssssssssssssssssssssssssss" +showApps.toString());
      appUsageInfoList = infoList;
      return showApps;
    } on AppUsageException catch (exception) {
      print(exception);
      return appUsageInfoList;
    }
  }

  List<String> setAppNamesList() {
    List<String> appNamesList = [];
    for (var appUsage in appUsageInfoList) {
      var appName = appUsage.appName;
      appNamesList.add(appName);
      print(appName);
    }
    appsNames = appNamesList;
    return appsNames;
  }

  Future<bool> saveUsageAlertInfo(String appName, int limit) async {
    print("Saving usage info.......");
    print("appName: $appName");
    print("limit: $limit");
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(appName, limit);
    return prefs.containsKey(appName);
  }

  Future<int> getUsageAlertInfo(String appName) async {
    print("Getting usage info.......");
    print("appName: $appName");
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(appName)) {
      var limit = prefs.getInt(appName);
      print("limit: $limit");
      return (limit != null) ? limit : 0;
    }
    return 0;
  }

  Future<void> triggerExcessUsageAlert(String appName) async {
    await getUsageStats();
    var limit = await getUsageAlertInfo(appName);
    int spentTime = 0;

    AppUsageInfo appUsage =
    appUsageInfoList.firstWhere((element) => element.appName == appName);

    spentTime = appUsage.usage.inMinutes;

    if (spentTime > limit) {
      print("WARNING!!!!! Excess usage of app $appName");
    }
  }

  Future<List<AppInfo>> getAllInstalledApps() async {
    try {

      List<AppInfo> appList =
      await InstalledApps.getInstalledApps(true, true);

      appInfo = appList;
      return appInfo;
    } on AppUsageException catch (exception) {
      print(exception);
      return appInfo;
    }
  }
}