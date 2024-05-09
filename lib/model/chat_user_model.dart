import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatUserModel {
String chatUserId;
String chatUserDeviceId;
  ChatUserModel({
    required this.chatUserId,
    required this.chatUserDeviceId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatUserId': chatUserId,
      'chatUserDeviceId': chatUserDeviceId,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      chatUserId: map['chatUserId'] as String,
      chatUserDeviceId: map['chatUserDeviceId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUserModel.fromJson(String source) => ChatUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
