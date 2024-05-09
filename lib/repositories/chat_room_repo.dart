import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/add_user_req_model.dart';
import 'package:spordee_messaging_app/model/auth_user_model.dart';
import 'package:spordee_messaging_app/model/chat_room_model.dart';
import 'package:spordee_messaging_app/model/chat_user_model.dart';
import 'package:spordee_messaging_app/model/response_model.dart';
import 'package:spordee_messaging_app/util/dio_initilizer.dart';
import 'package:spordee_messaging_app/util/dotenv.dart';
import 'package:spordee_messaging_app/util/exceptions.dart';

class ChatRoomRepo {
  final DioInit _dioInit = DioInit();
  final Logger log = Logger();
  // create chat room
  Future<ChatRoomModel?> createChatRoom({
    required String id,
    required String name,
    required String description,
    required String createdBy,
    required String deviceId,
  }) async {
    try {
      ChatRoomModel model = ChatRoomModel(
        publicChatRoomId: id,
        publicChatRoomName: name,
        description: description,
        createdBy: createdBy,
        deviceId: deviceId,
        updatedAt: "",
      );

      Response response = await _dioInit.dioInit.post(
        CREATE_CHAT_ROOM,
        data: model.toMap(),
      );
      Logger().d("response ${response.data}");
      if (response.data != null) {
        Logger().d("response ${response.data}");
        ResponseModel responseModel = ResponseModel.fromMap(response.data);

        if (responseModel.code != 201) {
          return null;
        }

        ChatRoomModel newModel =
            ChatRoomModel.fromMap(responseModel.data as Map<String, dynamic>);

        Logger().d("new model ${newModel.publicChatRoomId}");
        Logger().d("new model ${newModel.publicChatRoomName}");
        return newModel;
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        ResponseModel res = ResponseModel.fromMap(e.response!.data);
        ExceptionMessage().setMessage(res.message);
      }
      Logger().e(e.error);
      Logger().e(e.response);
      Logger().e(e.message);
      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<List<ChatRoomModel>> getAllRooms({
    required String userId,
    required String deviceId,
  }) async {
    List<ChatRoomModel> modelList = [];
    try {
      Response response = await _dioInit.dioInit.get(
        GET_ALL_ROOMS,
        data: ChatUserModel(
          chatUserId: userId,
          chatUserDeviceId: deviceId,
        ).toMap(),

      );
      log.i("Response:  ${response.data}");
      log.i("type:  ${response.data.runtimeType}");

      ResponseModel responseModel = ResponseModel.fromMap(response.data);

      if (responseModel.code != 200) {
        return [];
      }

      // casting
      List<dynamic> dynamicList = responseModel.data as List<dynamic>;

      for (var item in dynamicList.cast<Map<String, dynamic>>()) {
        // Map<String, dynamic> map = item;

        log.i("after convert type:  ${item.runtimeType}");
        ChatRoomModel model = ChatRoomModel.fromMap(item);
        log.i("model:  ${model.runtimeType}");
        modelList.add(model);
        log.i("List Length:  ${modelList.length}");
      }

      //  List<Map<String,dynamic>> c =  response.data as List<Map<String,dynamic>>;

    } on DioException catch (e) {
      log.e("DIO ERROR: ${e.error}");
      log.e("DIO ERROR: ${e.message}");
      log.e("DIO ERROR: ${e.response!.data}");
    } catch (e) {
      log.e("ERROR $e");
    }

    return modelList;
  }

  Future<AuthUserModel?> findByMobile(String mobile) async {
    try {
      Response response =
          await _dioInit.dioInit.get(getUserByMobilePath(mobile));
      if (response.data == null) {
        return null;
      }

      Logger().d("response ${response.data}");
      ResponseModel responseModel = ResponseModel.fromMap(response.data);

      log.i("RESPONSE: ${response.data}");
      AuthUserModel model =
          AuthUserModel.fromMap(responseModel.data as Map<String, dynamic>);
      log.i("MODEL: ${model.userId}");
      return model;
    } on DioException catch (e) {
      log.e("DIO ERROR: ${e.error}");
      log.e("DIO ERROR: ${e.response!.statusCode}");
      log.e("DIO ERROR: ${e.response!.data}");
      return null;
    } catch (e) {
      log.e("ERROR: $e");
      return null;
    }
  }

  Future<ChatRoomModel?> addUser({
    required String newUserId,
    required String newUserDeviceId,
    required String chatRoomId,
    required String adminId,
    required String adminDeviceId,
  }) async {
    try {
      Response reposnse = await _dioInit.dioInit.post(
        ADD_MEMBER_TO_CHAT,
        data: AddUserRequestModel(
          newUserId: newUserId,
          newUserDeviceId: newUserDeviceId,
          chatRoomId: chatRoomId,
          adminId: adminId,
          adminDeviceId: adminDeviceId,
        ).toMap(),
      );
      log.i(reposnse.data);

      ResponseModel responseModel = ResponseModel.fromMap(reposnse.data);

      if (responseModel.code == 403) {
        ExceptionMessage().setMessage("User Already in the list");
        return null;
      }

      if (responseModel.code == 404) {
        ExceptionMessage().setMessage("Room Not Available");
        return null;
      }

      if (responseModel.code == 201) {
        ChatRoomModel model =
            ChatRoomModel.fromMap(responseModel.data as Map<String, dynamic>);

        log.i(model.publicChatRoomId);
        return model;
      }

      ExceptionMessage().setMessage(responseModel.message);
      return null;
    } on DioException catch (e) {
      log.e(e.error);
      return null;
    } catch (e) {
      log.e(e);
      return null;
    }
  }

  Future<List<ChatUserModel>> getUsersList({
    required String roomId,
  }) async {
    try {
      Response response = await _dioInit.dioInit.get(
        getAllUserListPath(roomId),
      );
      if (response.data == null) {
        return [];
      }

      log.i("RESPONSE: ${response.data}");
      log.i("RESPONSE: ${response.data.runtimeType}");
      ResponseModel responseModel = ResponseModel.fromMap(response.data);
      if (responseModel.code == 200) {
        List<dynamic> lst = responseModel.data as List<dynamic>;

        return lst.map((e) => ChatUserModel.fromMap(e)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      log.e("DIO ERROR: ${e.error}");
      return [];
    } catch (e) {
      log.e("ERROR: $e");
      return [];
    }
  }
}
