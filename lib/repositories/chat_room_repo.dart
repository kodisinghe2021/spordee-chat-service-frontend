import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/auth_user_model.dart';
import 'package:spordee_messaging_app/model/chat_room_model.dart';
import 'package:spordee_messaging_app/util/dio_initilizer.dart';
import 'package:spordee_messaging_app/util/dotenv.dart';

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
        chatRoomId: id,
        name: name,
        description: description,
        createdBy: createdBy,
        deviceId: deviceId,
        updatedAt: "",
      );

      Response response = await _dioInit.dioInit.post(
        CREATE_CHAT_ROOM,
        data: model.toMap(),
      );
      if (response.data != null) {
        Logger().d("response ${response.data}");
        ChatRoomModel newModel = ChatRoomModel.fromMap(response.data);
        Logger().d("new model ${newModel.chatRoomId}");
        Logger().d("new model ${newModel.name}");
        return newModel;
      } else {
        return null;
      }
    } on DioException catch (e) {
      Logger().e(e.error);
      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<List<ChatRoomModel>> getAllRooms(String userId) async {
    List<ChatRoomModel> modelList = [];
    try {
      Response response = await _dioInit.dioInit.get(getChatRoomsPath(userId));
      log.i("Response:  ${response.data}");
      log.i("type:  ${response.data.runtimeType}");

      for (var item in response.data) {
        Map<String, dynamic> map = item as Map<String, dynamic>;
        log.i("after convert type:  ${map.runtimeType}");
        ChatRoomModel model = ChatRoomModel.fromMap(map);
        log.i("model:  ${model.runtimeType}");
        modelList.add(model);
        log.i("List Length:  ${modelList.length}");
      }

      //  List<Map<String,dynamic>> c =  response.data as List<Map<String,dynamic>>;

    } on DioException catch (e) {
      log.e("DIO ERROR: ${e.error}");
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

      log.i("RESPONSE: ${response.data}");
      AuthUserModel model = AuthUserModel.fromMap(response.data);
      log.i("MODEL: ${model.userId}");
      return model;
    } on DioException catch (e) {
      log.e("DIO ERROR: ${e.error}");
      return null;
    } catch (e) {
      log.e("ERROR: $e");
      return null;
    }
  }

  Future<ChatRoomModel?> addUser({
    required String room,
    required String memberId,
  }) async {
    try {
      Response reposnse = await _dioInit.dioInit.post(
        ADD_MEMBER_TO_CHAT,
        data: {
          "userId": memberId,
          "chatRoomId": room,
        },
      );
      log.i(reposnse.data);
      ChatRoomModel model = ChatRoomModel.fromMap(reposnse.data);
      log.i(model.chatRoomId);
      return model;
    } on DioException catch (e) {
      log.e(e.error);
      return null;
    } catch (e) {
      log.e(e);
      return null;
    }
  }

  Future<List<String>> getUsersList(String roomId) async {
    try {
      Response response =
          await _dioInit.dioInit.get(getAllUserListPath(roomId));
      if (response.data == null) {
        return [];
      }

      log.i("RESPONSE: ${response.data}");
      log.i("RESPONSE: ${response.data.runtimeType}");

      List<dynamic> lst = response.data as List<dynamic>;

      return lst.map((e) => e.toString()).toList();
    } on DioException catch (e) {
      log.e("DIO ERROR: ${e.error}");
      return [];
    } catch (e) {
      log.e("ERROR: $e");
      return [];
    }
  }
}