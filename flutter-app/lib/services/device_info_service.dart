import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfoService {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  bool isLowPowerDevice = false;

  AndroidDeviceInfo androidInfo;
  IosDeviceInfo iOSInfo;

  DeviceInfoService() {
    _setDeviceInfo();
  }

  Future<void> _setDeviceInfo() async {
    if (Platform.isIOS) {
      iOSInfo = await deviceInfo.iosInfo;

      // https://medium.com/ios-os-x-development/get-model-info-of-ios-devices-18bc8f32c254
      if (['iPhone8,1', 'iPhone8,2', 'iPhone8,4']
          .contains(iOSInfo.utsname.machine)) {
        isLowPowerDevice = true;
      }
    } else if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      isLowPowerDevice = true;
    }
  }
}
