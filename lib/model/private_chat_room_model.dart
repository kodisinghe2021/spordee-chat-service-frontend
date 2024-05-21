import 'dart:convert';

import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';

class PrivateChatRoomModel {
  ChatUserId chatUserA;
  ChatUserId chatUserB;
  String chatRoomId;
  String description;
  String createdBy;
  double lastMessageId;

  PrivateChatRoomModel({
    required this.chatUserA,
    required this.chatUserB,
    required this.chatRoomId,
    required this.description,
    required this.createdBy,
    required this.lastMessageId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatUserA': chatUserA,
      'chatUserB': chatUserB,
      'chatRoomId': chatRoomId,
      'description': description,
      'createdBy': createdBy,
      'lastMessageId': lastMessageId,
    };
  }

  factory PrivateChatRoomModel.fromMap(Map<String, dynamic> map) {
    return PrivateChatRoomModel(
      chatUserA: map['chatUserA'] != null
          ? ChatUserId.fromMap(map['chatUserA'] as Map<String, dynamic>)
          : ChatUserId(chatUserId: "", chatUserDeviceId: ""),
      chatUserB: map['chatUserB'] != null
          ? ChatUserId.fromMap(map['chatUserB'] as Map<String, dynamic>)
          : ChatUserId(chatUserId: "", chatUserDeviceId: ""),
      chatRoomId: map['chatRoomId'] != null ? map['chatRoomId'] as String : "",
      description:
          map['description'] != null ? map['description'] as String : "",
      createdBy: map['createdBy'] != null ? map['createdBy'] as String : "",
      lastMessageId:
          map['lastMessageId'] != null ? double.parse(map['lastMessageId']) : 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrivateChatRoomModel.fromJson(String source) =>
      PrivateChatRoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
