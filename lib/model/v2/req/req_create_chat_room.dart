// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:spordee_messaging_app/model/v2/chat_user.dart';
import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';

class ReqCreateChatRoom {
  String roomName;
  String description;
  ChatUserId createdBy;
  bool isPublic;
  List<ChatUser> chatUsers;
  List<ChatUser> adminList;

  ReqCreateChatRoom({
    required this.roomName,
    required this.description,
    required this.createdBy,
    required this.isPublic,
    required this.chatUsers,
    required this.adminList,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomName': roomName,
      'description': description,
      'createdBy': createdBy.toMap(),
      'isPublic': isPublic,
      'chatUsers': chatUsers.map((x) => x.toMap()).toList(),
      'adminList': adminList.map((x) => x.toMap()).toList(),
    };
  }

  // factory ReqCreateChatRoom.fromMap(Map<String, dynamic> map) {
  //   return ReqCreateChatRoom(
  //     roomName: map['roomName'] as String,
  //     description: map['description'] as String,
  //     createdBy: ChatUserId.fromMap(map['createdBy'] as Map<String, dynamic>),
  //     isPublic: map['isPublic'] as bool,
  //     usersList: List<ChatUser>.from(
  //       (map['usersList'] as List<int>).map<ChatUser>(
  //         (x) => ChatUser.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //     adminList: List<ChatUser>.from(
  //       (map['adminList'] as List<int>).map<ChatUser>(
  //         (x) => ChatUser.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory ReqCreateChatRoom.fromJson(String source) =>
      // ReqCreateChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);
}
