// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';

class Message {
final String chatRoomId;
final String message;
final String sendersId;
final String sentTime;
final String messageCategory;
final List<ChatUserId> chatUserIdSet;

  Message({
    required this.chatRoomId,
    required this.message,
    required this.sendersId,
    required this.sentTime,
    required this.messageCategory,
    required this.chatUserIdSet,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatRoomId': chatRoomId,
      'message': message,
      'sendersId': sendersId,
      'sentTime': sentTime,
      'messageCategory': messageCategory,
      'chatUserIdSet': chatUserIdSet.map((x) => x.toMap()).toList(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      chatRoomId: map['chatRoomId'].toString(),
      message: map['message'].toString(),
      sendersId: map['sendersId'].toString(),
      sentTime: map['sentTime'].toString(),
      messageCategory: map['messageCategory'].toString(),
      chatUserIdSet:map['chatUserIdSet']!=null? List<ChatUserId>.from((map['chatUserIdSet'] as List<dynamic>).map<ChatUserId>((x) => ChatUserId.fromMap(x as Map<String,dynamic>),),):[],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
