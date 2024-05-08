import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/root_home.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  String? deviceId = androidInfo.fingerprint;
  if (deviceId != null) {
    Logger().i("device ID :: $deviceId");
   await LocalStore().addToLocal(Keys.deviceId, deviceId);
  }
  runApp(const RootHome());
}
