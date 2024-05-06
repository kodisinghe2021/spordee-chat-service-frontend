import 'package:flutter/material.dart';
import 'package:spordee_messaging_app/model/send_message_model.dart';

class RoomPageMessageList extends ChangeNotifier {
  RoomPageMessageList._internal();
  static final RoomPageMessageList _instance = RoomPageMessageList._internal();
  factory RoomPageMessageList() => _instance;
  final ScrollController scrollController = ScrollController();
  List<SendMessageModel> _messages = [];


  void putMessage(SendMessageModel model) {
    
    _messages.insert(0, model);
    notifyListeners();
    scrollController.animateTo(
      scrollController.position.physics.minFlingVelocity-60,
     // scrollController.position.maxScrollExtent+80,
      duration: const Duration(milliseconds: 600),
      curve: Curves.bounceOut,
    );
  }

  void putMessageList(List<SendMessageModel> models) {
    _messages = models;
    notifyListeners();
  }

  void clearMessages(){
    _messages.clear();
    notifyListeners();
  }
  List<SendMessageModel> get messages => _messages;
}
