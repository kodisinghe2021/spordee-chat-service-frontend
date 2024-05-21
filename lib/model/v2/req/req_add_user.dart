// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';

class ReqAddUser {
  final ChatUserId adminUserId;
  final ChatUserId newUserId;
  final String chatRoomId;
  ReqAddUser({
    required this.adminUserId,
    required this.newUserId,
    required this.chatRoomId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adminUserId': adminUserId.toMap(),
      'newUserId': newUserId.toMap(),
      'chatRoomId': chatRoomId,
    };
  }

  String toJson() => json.encode(toMap());

}
