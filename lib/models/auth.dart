import 'package:device_info/device_info.dart';
import 'dart:io';

class Auth {
  final deviceInfoPlugin = DeviceInfoPlugin();

  void deviceID() async {
    String _deviceID = 'Device not identified';
    if (Platform.isAndroid) {
      _deviceID =
          await deviceInfoPlugin.androidInfo.then((_build) => _build.androidId);
    } else if (Platform.isIOS) {
      _deviceID = await deviceInfoPlugin.iosInfo
          .then((_build) => _build.identifierForVendor);
    }
    print(_deviceID);
  }
}
