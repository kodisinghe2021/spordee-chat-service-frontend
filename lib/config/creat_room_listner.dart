import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/controllers/chat_room_screen_controller.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/dotenv.dart';
import 'package:spordee_messaging_app/util/keys.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

//==================================== init stomp client and activate
Future<bool> activeChatRoom() async {
  Logger().i("ACTIVATE>>>>");
  stompClientChatRoom.activate();
  if (stompClientChatRoom.connected) {
    Logger().i("Connected.........");
  }
  await Future.delayed(const Duration(milliseconds: 1000));
  return true;
}

Future<void> disconnectChatRoom() async {
  stompClientChatRoom.deactivate();
  await Future.delayed(const Duration(milliseconds: 500));
}

//==================================== Make stomp client object
final stompClientChatRoom = StompClient(
  config: StompConfig(
    url: WS_URL,
    onConnect: subscribeChatRoom,
    onWebSocketDone: () async {
      Logger().i('Connection Done !');
    },
    onDisconnect: (StompFrame frame) async {
      Logger().i('Disconnected ... ${frame.body}');
    },
    beforeConnect: () async {
      Logger().i('waiting to connect...');
    },
    onWebSocketError: (dynamic error) =>
        Logger().e("Connection ERRPR:: ${error.toString()}"),
    stompConnectHeaders: {'SUBSCRIBE': ''},
    // webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
  ),
);

//====================================== Subscribe stomp client
void subscribeChatRoom(StompFrame frame) async {
  // MessageProvider messageProvider = MessageProvider();
  Logger().i("ON CONNECT ++++==>> Triggered");
  final chatRoomId = await LocalStore().getFromLocal(Keys.roomId);
  final userId = await LocalStore().getFromLocal(Keys.userId);
  final String? deviceId = await LocalStore().getFromLocal(Keys.deviceId);
  if (chatRoomId == null) {
    Logger().d("Chat Room ID IS EMPTY");
    return;
  }
  if (userId == null) {
    Logger().d("USER ID IS EMPTY");
    return;
  }
  if (deviceId == null) {
    Logger().d("DEVICE ID IS EMPTY");
    return;
  }
  Logger().d("Chat Room ID:: $chatRoomId");
  Logger().w("Waiting for subscribe");
  await Future.delayed(const Duration(milliseconds: 1000));
  stompClientChatRoom.subscribe(
      destination: wsSubscribe(chatRoomId),
      callback: (frame) {
        Logger().i("On Subscribe :: Callback :: ==>> ${frame.body.toString()}");

        if (frame.body != null) {
          Map<String, dynamic> res =
              jsonDecode(frame.body.toString()) as Map<String, dynamic>;

//=======================================================  NEW MESSAGE RECEIVED
          Logger().i("Message from Socket: $res");
          ChatRoomScreenController().newMessageReceived(res, chatRoomId);
          // MessageModel sendMessageModel = MessageModel.fromMap(res);
          // RoomPageMessageList().putMessage(sendMessageModel, chatRoomId);
          // if (sendMessageModel.category == MessageCategory.JOIN.name) {
          //   RoomProvider().addUsersList(sendMessageModel.receiversIdSet);
          // }
//=======================================================  NEW MESSAGE RECEIVED
        } else {
          Logger().i("body is null");
        }
      },
      headers: {
        "userid": userId,
        "roomid": chatRoomId,
        "deviceId": deviceId,
      });
  // stompClient.send(
  //   destination: wsSubscribe(chatRoomId),
  //   body: jsonEncode({"body": userId}),
  //   headers: {
  //     "SUBSCRIBE":userId!,
  //     "head": userId,
  //   },
  // );
}

// void sendMessage(MessageModel message, String chatRoomId) async {
//   stompClient.send(
//     destination: wsSubscribe(chatRoomId),
//     body: message.toJson(),
//   );
// }