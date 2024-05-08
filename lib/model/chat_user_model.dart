import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatUserModel {
String id;
String deviceId;
  ChatUserModel({
    required this.id,
    required this.deviceId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deviceId': deviceId,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      id: map['id'] as String,
      deviceId: map['deviceId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUserModel.fromJson(String source) => ChatUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
