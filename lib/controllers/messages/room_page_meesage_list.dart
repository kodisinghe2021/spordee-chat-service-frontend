import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spordee_messaging_app/model/message_model.dart';

class RoomPageMessageList extends ChangeNotifier {
  RoomPageMessageList._internal();
  static final RoomPageMessageList _instance = RoomPageMessageList._internal();
  factory RoomPageMessageList() => _instance;
  final ScrollController scrollController = ScrollController();
  List<MessageModel> _messages = [];

  //---- this function triggered by the socket listner
  void putMessage(MessageModel model, String roomId) async {
    await saveMessages(roomId, model);
    List<MessageModel> modelList = await getMessages(roomId);

    _messages = modelList;

    notifyListeners();
    scrollController.animateTo(
      scrollController.position.physics.minFlingVelocity - 60,
      duration: const Duration(milliseconds: 600),
      curve: Curves.bounceOut,
    );
  }

  // --- this function for get all offline messages
  void putMessageList(List<MessageModel> models, String roomId) {
    if(models.isEmpty){
      return;
    }
    for (var item in models) {
      putMessage(item, roomId);
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  // initial load from the local
  Future<void> addToOnMemoryFromLocal(String roomId) async {
    List<MessageModel> modelList = await getMessages(roomId);
    _messages = modelList;
  }

  List<MessageModel> get messages => _messages;
}

Future<void> saveMessages(String roomId, MessageModel messageModel) async {
  var box = await Hive.openBox<MessageModel>(roomId);
  await box.putAt(box.length, messageModel);
}

Future<List<MessageModel>> getMessages(String roomId) async {
  var box = await Hive.openBox<MessageModel>(roomId);
  // To retrieve your SendMessageModel objects
  List<MessageModel> savedMessages = box.values.toList();
  return savedMessages;
}
