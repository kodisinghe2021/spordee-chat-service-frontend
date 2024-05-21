import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/chat_room_model.dart';
import 'package:spordee_messaging_app/model/v2/chat_user.dart';
import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';
import 'package:spordee_messaging_app/model/private_chat_room_model.dart';
import 'package:spordee_messaging_app/model/response_model.dart';
import 'package:spordee_messaging_app/model/message_model.dart';
import 'package:spordee_messaging_app/model/v2/req/req_create_chat_room.dart';
import 'package:spordee_messaging_app/model/v2/res/res_chat_room.dart';
import 'package:spordee_messaging_app/util/constant.dart';
import 'package:spordee_messaging_app/util/dio_initilizer.dart';
import 'package:spordee_messaging_app/util/dotenv.dart';
import 'package:spordee_messaging_app/util/exceptions.dart';

class PrivateChatRoomRepo {
  final DioInit _dioInit = DioInit();
  final Logger log = Logger();

  // create chat room
  Future<ResChatRoom?> createPrivateChatRoom({
    required ChatUser user,
    required ChatUser chatUserB,
    required String description,
  }) async {
    try {
      ReqCreateChatRoom model = ReqCreateChatRoom(
        createdBy: chatUserB.chatUserId,
        description: description,
        isPublic: false,
        roomName: "private-chat",
        adminList: [
          user,
          chatUserB,
        ],
        chatUsers: [
          user,
          chatUserB,
        ],
      );
      Logger().d("ChatUsers List 0 :: ${model.chatUsers[0].mobile}");
      Logger().d("ChatUsers List 1 :: ${model.chatUsers[1].mobile}");
      Response response = await _dioInit.dioInit.post(
        CREATE_CHAT_ROOM,
        data: model.toMap(),
      );

      Logger().d("response ${response.data}");
      if (response.data != null) {
        Logger().d("response ${response.data}");
        ResponseModel responseModel = ResponseModel.fromMap(response.data);

        ResChatRoom newModel =
            ResChatRoom.fromMap(responseModel.data as Map<String, dynamic>);

        Logger().d("new model ${newModel.chatRoomId}");
        Logger().d("new model ${newModel.chatRoomId}");
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
}
