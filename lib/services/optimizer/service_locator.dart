import 'package:get_it/get_it.dart';
import 'package:ctse_app_life_saviour/services/optimizer/app_usage_service.dart';

GetIt locator = GetIt.instance;

SetUpServiceLocator() {
  locator.registerLazySingleton<AppUsageService>(() => AppUsageService());
}
