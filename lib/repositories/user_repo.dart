import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/auth_user_model.dart';
import 'package:spordee_messaging_app/model/response_model.dart';
import 'package:spordee_messaging_app/util/dio_initilizer.dart';
import 'package:spordee_messaging_app/util/dotenv.dart';
import 'package:spordee_messaging_app/util/exceptions.dart';
import 'package:spordee_messaging_app/util/status_code.dart';

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
      Response response = await _dioInit.dioInit.post(LOGIN + "/" + mobile);
      Logger().d("Response status code: ${response.statusCode}");
      Logger().d("Response body: ${response.data}");
      if (response.data == null) {
        return null;
      }

      ResponseModel responseModel = ResponseModel.fromMap(response.data);

      Logger().d("Response model: > ${responseModel.data}");
      // converted to map
      AuthUserModel newModel =
          AuthUserModel.fromMap(responseModel.data as Map<String, dynamic>);
      return newModel;
    } on DioException catch (e) {
      if (e.response!.statusCode == sCodeUnauthorized) {
        ExceptionMessage().setMessage("Invalid Credintial");
      }
      ResponseModel model = ResponseModel.fromMap(e.response!.data);
      ExceptionMessage().setMessage(model.message);

      Logger().e("Dio error: ${e.error}");
      Logger().e("Dio error: ${e.message}");
      Logger().e("Dio error: ${e.response!.data}");
      Logger().e("Dio error: ${e.response!.statusCode}");
      return null;
    } catch (e) {
      Logger().e("error: $e");
      return null;
    }
  }
}
