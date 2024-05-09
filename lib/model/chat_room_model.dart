import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first


class ChatRoomModel {
  
   String publicChatRoomId;
   String publicChatRoomName;
   String description;
   String createdBy;
   String deviceId;
   String updatedAt;
  ChatRoomModel({
    required this.publicChatRoomId,
    required this.publicChatRoomName,
    required this.description,
    required this.createdBy,
    required this.deviceId,
    required this.updatedAt,
  });
   

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'publicChatRoomId': publicChatRoomId,
      'name': publicChatRoomName,
      'description': description,
      'createdBy': createdBy,
      'deviceId': deviceId,
      'updatedAt': updatedAt,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      publicChatRoomId:map['publicChatRoomId']!=null? map['publicChatRoomId'] as String:"",
      publicChatRoomName: map['publicChatRoomName']!=null? map['publicChatRoomName'] as String:"",
      description: map['description']!=null? map['description'] as String:"",
      createdBy: map['createdBy'] !=null?map['createdBy']  as String:"",
      deviceId: map['deviceId']!=null? map['deviceId']  as String:"",
      updatedAt: map['updatedAt'] !=null? map['updatedAt']  as String:"",
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) => ChatRoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
