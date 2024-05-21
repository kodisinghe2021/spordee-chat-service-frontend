import 'dart:convert';

import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  final String chatRoomId;
  final double messageId;
  final String message;
  final String sendersId;
  final String sentTime;
  final List<ChatUserId> chatUserIdSet;
  final String messageCategory;
 
  MessageModel({
    required this.chatRoomId,
    required this.messageId,
    required this.message,
    required this.sendersId,
    required this.sentTime,
    required this.chatUserIdSet,
    required this.messageCategory,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatRoomId': chatRoomId,
      'messageId': messageId,
      'message': message,
      'sendersId': sendersId,
      'sentTime': sentTime,
      'chatUserIdSet': chatUserIdSet.map((x) => x.toMap()).toList(),
      'messageCategory': messageCategory,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      chatRoomId: map['chatRoomId'].toString(),
      messageId: map['messageId'] != null
          ? double.parse(map['messageId'].toString())
          : 0,
      message: map['message'].toString(),
      sendersId: map['sendersId'].toString(),
      sentTime: map['sentTime'].toString(),
      chatUserIdSet: map['chatUserIdSet'] != null
          ? List<ChatUserId>.from(
              (map['chatUserIdSet'] as List<dynamic>)
                  .map((r) => r as Map<String, dynamic>)
                  .map<ChatUserId>(
                    (x) => ChatUserId.fromMap(x),
                  ),
            )
          : [],
      messageCategory: map['messageCategory'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
