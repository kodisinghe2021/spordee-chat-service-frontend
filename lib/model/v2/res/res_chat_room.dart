// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:spordee_messaging_app/model/v2/chat_user.dart';
import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';

class ResChatRoom {
  String chatRoomId;
  String roomName;
  String description;
  ChatUserId createdBy;
  double lastMessageId;
  List<ChatUser> chatUsers;
  List<ChatUser> adminList;
  ResChatRoom({
    required this.chatRoomId,
    required this.roomName,
    required this.description,
    required this.createdBy,
    required this.lastMessageId,
    required this.chatUsers,
    required this.adminList,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatRoomId': chatRoomId,
      'roomName': roomName,
      'description': description,
      'createdBy': createdBy.toMap(),
      'lastMessageId': lastMessageId,
      'chatUsers': chatUsers.map((x) => x.toMap()).toList(),
      'adminList': adminList.map((x) => x.toMap()).toList(),
    };
  }

  factory ResChatRoom.fromMap(Map<String, dynamic> map) {
    return ResChatRoom(
      chatRoomId: map['chatRoomId'].toString(),
      roomName: map['roomName'].toString(),
      description: map['description'].toString(),
      createdBy: map['createdBy'] != null
          ? ChatUserId.fromMap(map['createdBy'] as Map<String, dynamic>)
          : ChatUserId.empty(),
      lastMessageId: map['lastMessageId'] != null
          ? double.parse(map['lastMessageId'].toString())
          : 0,
      chatUsers: map['chatUsers'] != null
          ? List<ChatUser>.from(
              (map['chatUsers'] as List<dynamic>)
                  .map((e) => e as Map<String, dynamic>)
                  .toList()
                  .map<ChatUser>(
                    (x) => ChatUser.fromMap(x),
                  ),
            )
          : [],
      adminList: map['adminList'] != null
          ? List<ChatUser>.from(
              (map['adminList'] as List<dynamic>)
                  .map((e) => e as Map<String, dynamic>)
                  .toList()
                  .map<ChatUser>(
                    (x) => ChatUser.fromMap(x),
                  ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResChatRoom.fromJson(String source) =>
      ResChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);
}
