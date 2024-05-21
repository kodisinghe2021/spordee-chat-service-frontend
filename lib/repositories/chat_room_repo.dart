import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/v2/req/req_add_user.dart';
import 'package:spordee_messaging_app/model/auth_user_model.dart';
import 'package:spordee_messaging_app/model/chat_room_model.dart';
import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';
import 'package:spordee_messaging_app/model/response_model.dart';
import 'package:spordee_messaging_app/model/v2/req/req_create_chat_room.dart';
import 'package:spordee_messaging_app/model/v2/res/res_chat_room.dart';
import 'package:spordee_messaging_app/util/dio_initilizer.dart';
import 'package:spordee_messaging_app/util/dotenv.dart';
import 'package:spordee_messaging_app/util/exceptions.dart';

class ChatRoomRepo {
  final DioInit _dioInit = DioInit();
  final Logger log = Logger();
  // create chat room
  Future<ResChatRoom?> createChatRoom({
    required String id,
    required String name,
    required String description,
    required String createdBy,
    required String deviceId,
    required bool isPublic,
  }) async {
    try {
      // ChatRoomModel model = ChatRoomModel(
      //   publicChatRoomId: id,
      //   publicChatRoomName: name,
      //   description: description,
      //   createdBy: createdBy,
      //   deviceId: deviceId,
      //   updatedAt: "",
      // );

      // TODO: new model add here
      ReqCreateChatRoom model = ReqCreateChatRoom(
        roomName: name,
        description: description,
        createdBy:
            ChatUserId(chatUserId: createdBy, chatUserDeviceId: deviceId),
            chatUsers: [],
            adminList: [],
        isPublic: isPublic,
      );

      Response response = await _dioInit.dioInit.post(
        CREATE_CHAT_ROOM,
        data: model.toMap(),
      );

      Logger().d("response ${response.data}");
      if (response.data != null) {
        Logger().d("response ${response.data}");
        ResponseModel responseModel = ResponseModel.fromMap(response.data);

        if (responseModel.code != 200) {
          return null;
        }

        ResChatRoom newModel =
            ResChatRoom.fromMap(responseModel.data as Map<String, dynamic>);

        Logger().d("new model ${newModel.chatRoomId}");
        Logger().d("new model ${newModel.createdBy}");
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

  Future<List<ResChatRoom>> getAllRoomsByChatUserId({
    required String userId,
    required String deviceId,
  }) async {
    List<ResChatRoom> modelList = [];
    try {
      Response response = await _dioInit.dioInit.get(
        GET_ALL_ROOMS,
        data: ChatUserId(
          chatUserId: userId,
          chatUserDeviceId: deviceId,
        ).toMap(),
      );
      log.i("Response:  ${response.data}");
      log.i("type:  ${response.data.runtimeType}");

      ResponseModel responseModel = ResponseModel.fromMap(response.data);
      log.i("response model data type:  ${responseModel.data.runtimeType}");

      if (responseModel.code != 200) {
        return [];
      }

      List<dynamic> dynamicList = responseModel.data as List<dynamic>;

      List<Map<String, dynamic>> castedList =
          dynamicList.map((e) => e as Map<String, dynamic>).toList();
      // List<Map<String,dynamic>> castedList = dynamicList as List<Map<String,dynamic>>;

      Logger().i("castedList : ${castedList.runtimeType}");

      for (var item in castedList) {
        // Map<String, dynamic> map = item;
        ResChatRoom model = ResChatRoom.fromMap(item);
        modelList.add(model);
        log.i(
            "chat device id : :: ${model.adminList.first.chatUserId.chatUserDeviceId}");
        log.i(
            "chat user id : :: ${model.adminList.first.chatUserId.chatUserId}");
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

  Future<ResChatRoom?> addUser({
    required String newUserId,
    required String newUserDeviceId,
    required String chatRoomId,
    required String adminId,
    required String adminDeviceId,
  }) async {
    try {
      log.d("Going to send request");
      Map<String, dynamic> map = ReqAddUser(
        adminUserId: ChatUserId(
          chatUserId: adminId,
          chatUserDeviceId: adminDeviceId,
        ),
        newUserId: ChatUserId(
          chatUserId: newUserId,
          chatUserDeviceId: newUserDeviceId,
        ),
        chatRoomId: chatRoomId,
      ).toMap();

      Response reposnse = await _dioInit.dioInit.post(
        ADD_MEMBER_TO_CHAT,
        data: map,
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

      if (responseModel.code == 200) {
        ResChatRoom model =
            ResChatRoom.fromMap(responseModel.data as Map<String, dynamic>);

        log.i(model.chatRoomId);
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

  Future<List<ChatUserId>> getUsersList({
    required String roomId,
  }) async {
    try {
      Response response = await _dioInit.dioInit.get(
        getAllUsersByRoomIdPath(roomId),
      );
      if (response.data == null) {
        return [];
      }

      log.i("RESPONSE: ${response.data}");
      log.i("RESPONSE: ${response.data.runtimeType}");
      ResponseModel responseModel = ResponseModel.fromMap(response.data);
      if (responseModel.code == 200) {
        List<dynamic> lst = responseModel.data as List<dynamic>;
       return lst.map((e) => e as Map<String,dynamic>).toList().map((m) => ChatUserId.fromMap(m)).toList();
        // return lst.map((e) => ChatUserId.fromMap(e)).toList();
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
