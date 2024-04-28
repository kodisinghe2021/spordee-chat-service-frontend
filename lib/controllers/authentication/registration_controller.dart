import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';
import 'package:spordee_messaging_app/model/auth_user_model.dart';
import 'package:spordee_messaging_app/repositories/user_repo.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/keys.dart';

class RegistrationController {
  final UserRepo _userRepo = UserRepo();
  final LocalStore _localStore = LocalStore();
  final Logger log = Logger();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<bool> register({
    required String name,
    required String mobile,
  }) async {
    final baseDeviceInfo = await _deviceInfo.deviceInfo;
    log.d("Base device info: ${baseDeviceInfo.toMap.toString()}");
    AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
    String? deviceID = androidInfo.fingerprint;
    log.d("DEVICE ID :: ${deviceID.toString()}");
    if (deviceID == null) {
      log.e("DEVICE ID NULL");
      return false;
    }
    AuthUserModel? authUserModel = await _userRepo.registerUser(
      userId: "",
      name: name,
      mobile: mobile,
      deviceId: deviceID,
    );
    if (authUserModel != null) {
      log.i("User Model ${authUserModel.userId}");
      bool isSuccces =
          await _localStore.addToLocal(Keys.userId, authUserModel.userId);
      await AuthenticationProvider().authenticate();
      return isSuccces;
    } else {
      return false;
    }
  }
}
