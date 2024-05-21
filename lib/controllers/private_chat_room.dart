import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/auth_user_model.dart';
import 'package:spordee_messaging_app/model/v2/chat_user.dart';
import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';
import 'package:spordee_messaging_app/model/v2/res/res_chat_room.dart';
import 'package:spordee_messaging_app/repositories/chat_room_repo.dart';
import 'package:spordee_messaging_app/repositories/private_chat_room_repo.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/keys.dart';

class PrivateChatRoomController with ChangeNotifier {
  PrivateChatRoomController._internal();
  static final PrivateChatRoomController _instance =
      PrivateChatRoomController._internal();
  factory PrivateChatRoomController() => _instance;

  // ====== DI
  final PrivateChatRoomRepo _privateChatRoomRepo = PrivateChatRoomRepo();
  final ChatRoomRepo _chatRoomRepo = ChatRoomRepo();
  final LocalStore _localStore = LocalStore();
  final Logger _l = Logger();

  Future<bool> createNewPrivateChat({required String userName}) async {
    String? userId = await _localStore.getFromLocal(Keys.userId);
    String? deviceId = await _localStore.getFromLocal(Keys.deviceId);
    String? mobile = await _localStore.getFromLocal(Keys.mobile);

    if (userId == null) {
      _l.e("User Id is null");
      return false;
    }
    if (deviceId == null) {
      _l.e("Device Id is null");
      return false;
    }

    if (mobile == null) {
      _l.e("Mobile is null");
      return false;
    }

    // make ChatUserId
    ChatUserId chatUserId = ChatUserId(
      chatUserId: userId,
      chatUserDeviceId: deviceId,
    );

    // search for chat user
    AuthUserModel? friendModel = await _chatRoomRepo.findByMobile(userName);

    // check user is avaialble or not
    if (friendModel == null) {
      _l.e("User Not found by this number");
      return false;
    }

    _l.i("User found ll: ${friendModel.name}");

    ResChatRoom? newPrivateChatRoomModel =
        await _privateChatRoomRepo.createPrivateChatRoom(
      user: ChatUser(chatUserId: chatUserId, mobile: mobile),
      chatUserB: ChatUser(
        chatUserId: ChatUserId(
            chatUserId: friendModel.userId,
            chatUserDeviceId: friendModel.deviceId),
        mobile: friendModel.mobile,
      ),
      description: "default description",
    );
    

    if (newPrivateChatRoomModel == null) {
      _l.e("room null");
      return false;
    }
    _l.i("Room created :: ID ${newPrivateChatRoomModel.chatRoomId}");
    return true;
  }
}
