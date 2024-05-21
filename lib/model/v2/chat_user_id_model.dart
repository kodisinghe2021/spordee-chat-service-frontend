import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatUserId {
String chatUserId;
String chatUserDeviceId;
  ChatUserId({
    required this.chatUserId,
    required this.chatUserDeviceId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatUserId': chatUserId,
      'chatUserDeviceId': chatUserDeviceId,
    };
  }

  factory ChatUserId.fromMap(Map<String, dynamic> map) {
    return ChatUserId(
      chatUserId: map['chatUserId'].toString(),
      chatUserDeviceId: map['chatUserDeviceId'].toString(),
    );
  }

  factory ChatUserId.empty(){
    return ChatUserId(chatUserId: "", chatUserDeviceId: "");
  }

  String toJson() => json.encode(toMap());

  factory ChatUserId.fromJson(String source) => ChatUserId.fromMap(json.decode(source) as Map<String, dynamic>);
}
