import 'package:gentle/services/device_info_service.dart';
import 'package:gentle/services/error_reporter.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

void setupLocater() {
  sl.registerSingleton<ErrorReporter>(ErrorReporter());
  sl.registerSingleton<DeviceInfoService>(DeviceInfoService());
}
