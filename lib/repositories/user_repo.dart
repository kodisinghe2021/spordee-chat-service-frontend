import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/auth_user_model.dart';
import 'package:spordee_messaging_app/util/dio_initilizer.dart';
import 'package:spordee_messaging_app/util/dotenv.dart';

class UserRepo {
  final DioInit _dioInit = DioInit();

  Future<void> getUser(String userID) async {
    Logger().v("getUser() >>>>>");

    try {
      Response response = await _dioInit.dioInit.get(
        getUserPath(userID),
      );
      Logger().d("Response status code: ${response.statusCode}");
      Logger().d("Response body: ${response.data}");
      // converted to map
      AuthUserModel newModel = AuthUserModel.fromMap(response.data);
      // return newModel;
    } on DioException catch (e) {
      Logger().e("Dio error: ${e.error}");
      return null;
    } catch (e) {
      Logger().e("error: $e");
      return null;
    }
  }

  Future<void> getUserByMobile(String mobile) async {
    Logger().v("getUser() >>>>>");

    try {
      Response response = await _dioInit.dioInit.get(
        getUserByMobilePath(mobile),
      );
      Logger().d("Response status code: ${response.statusCode}");
      Logger().d("Response body: ${response.data}");
      // converted to map
      AuthUserModel newModel = AuthUserModel.fromMap(response.data);
      // return newModel;
    } on DioException catch (e) {
      Logger().e("Dio error: ${e.error}");
      return null;
    } catch (e) {
      Logger().e("error: $e");
      return null;
    }
  }

  Future<AuthUserModel?> registerUser({
    required String userId,
    required String name,
    required String mobile,
    required String deviceId,
  }) async {
    Logger().v("registerUser() >>>>>");

    // make model
    AuthUserModel model = AuthUserModel(
      userId: userId,
      name: name,
      mobile: mobile,
      deviceId: deviceId,
    );

    try {
      Response response = await _dioInit.dioInit.post(
        REGISTER_USER,
        data: model.toMap(),
      );
      Logger().d("Response status code: ${response.statusCode}");
      Logger().d("Response body: ${response.data}");
      // converted to map
      AuthUserModel newModel = AuthUserModel.fromMap(response.data);
      return newModel;
    } on DioException catch (e) {
      Logger().e("Dio error: ${e.error}");
      return null;
    } catch (e) {
      Logger().e("error: $e");
      return null;
    }
  }

  Future<AuthUserModel?> login({required String mobile}) async {
    try {
      final response = await _dioInit.dioInit.post(LOGIN + "/" + mobile);
      //  print(${response.})
      Logger().d("Response status code: ${response.statusCode}");
      Logger().d("Response body: ${response.data}");

      // converted to map
      // AuthUserModel newModel = AuthUserModel.fromMap(response.data);
      return null;
    } on DioException catch (e) {
      Logger().e("Dio error: ${e.error}");
      return null;
    } catch (e) {
      Logger().e("error: $e");
      return null;
    }
  }
}
