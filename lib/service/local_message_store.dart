import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/send_message_model.dart';

class LocalMessageStore {
  var roomBox = Hive.box('chatRooms');
  final Logger log = Logger();

  Future<void> putMessageToChatRoom(
    String roomId,
    SendMessageModel messageModel,
  ) async {

    if (roomBox.containsKey(roomId)) {
      final data = await roomBox.get(roomBox);
      log.d("DATA :: ${data.runtimeType}");

      List<dynamic> lst = data as List<dynamic>;
      log.d("lst :: ${lst.runtimeType}");

      final maps = lst.map((e) => e as Map<dynamic, dynamic>).toList();
      log.d("maps :: ${maps.runtimeType}");

    } else {
      List<Map<String,dynamic>> convertedList = [];
      convertedList.add(messageModel.toMap());

      await roomBox.put(roomId, convertedList);
      log.i("Message added succesfully");
    }

  }

}
