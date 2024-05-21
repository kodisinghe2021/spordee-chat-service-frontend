import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/controllers/messages/room_page_meesage_list.dart';
import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';
import 'package:spordee_messaging_app/model/message_model.dart';
import 'package:spordee_messaging_app/repositories/message_repo.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/constant.dart';
import 'package:spordee_messaging_app/util/keys.dart';

class MessageProvider with ChangeNotifier {
  MessageProvider._internal();
  static final MessageProvider _instance = MessageProvider._internal();
  factory MessageProvider() => _instance;

  final LocalStore _localStore = LocalStore();
  final Logger _log = Logger();
  final MessageRepo _messageRepo = MessageRepo();

  int _page = 0;

  void setPage(bool isUp) {
    if (isUp) {
      _page++;
    } else {
      _page--;
    }
  }

  int get getterPage => _page;

  // List<SendMessageModel> _messages = [];

  // void addMessage(SendMessageModel messageModel) {
  //   _messages.add(messageModel);
  //   notifyListeners();
  // }

  // void addMessageList(List<SendMessageModel> messageModels) {
  //   _messages = messageModels;
  //   notifyListeners();
  // }

  Future<void> sendMessage({
    required String message,
    required List<ChatUserId> roomUsers,
  }) async {
    String? userId = await _localStore.getFromLocal(Keys.userId);
    String? roomId = await _localStore.getFromLocal(Keys.roomId);
    String? deviceId = await _localStore.getFromLocal(Keys.deviceId);
    if (userId == null || roomId == null || deviceId == null) {
      _log.w("Some Value NULL");
      return;
    }
    await _messageRepo.sendPublicMessage(
      message: message,
      userId: userId,
      roomUsers: roomUsers,
      category: MessageCategory.PUBLIC,
      roomId: roomId, deviceId: deviceId,
    );
  }

  Future<void> getOfflineMessages({
    required String roomId,
  }) async {
    String? userId = await _localStore.getFromLocal(Keys.userId);
    String? deviceId = await _localStore.getFromLocal(Keys.deviceId);

    if (userId == null ) {
      _log.w("userId null");
      return;
    }
    if (deviceId == null ) {
      _log.w("deviceId null");
      return;
    }
    if (roomId.isEmpty ) {
      _log.w("roomId empty");
      return;
    }

    List<MessageModel> messages =
        await _messageRepo.getOfflineMessages(userId, roomId, deviceId);
    _log.d("List Caught from provider  ${messages.length}");
    _log.d("List Caught from provider  $messages");

    RoomPageMessageList().putMessageList(messages, roomId);
    return;
  }

  // Future<void> getMessagesWithPage() async {
  //   String? userId = await _localStore.getFromLocal(Keys.userId);
  //   String? roomId = await _localStore.getFromLocal(Keys.roomId);
  //   if (userId == null || roomId == null) {
  //     _log.w("User id or room id is null");
  //     return;
  //   }

  //   List<SendMessageModel> messages = await _messageRepo.getPaginatedMessages(
  //     roomId: roomId,
  //     userId: userId,
  //     size: 10,
  //     page: getterPage,
  //   );

  //   _log.d("List Caught from provider  ${messages.length}");
  //   _log.d("List Caught from provider  $messages");
  //   if (getterPage < 1) {
  //     RoomPageMessageList().putMessageList(messages);
  //   } else {
  //     List<SendMessageModel> currentModels = RoomPageMessageList().messages;
  //     currentModels.insertAll(0, messages);
  //     RoomPageMessageList().putMessageList(currentModels);
  //   }
  // }
}


