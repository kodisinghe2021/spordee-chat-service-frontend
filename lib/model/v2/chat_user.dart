// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';

class ChatUser {
  final ChatUserId chatUserId;
  final String mobile;
  ChatUser({
    required this.chatUserId,
    required this.mobile,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatUserId': chatUserId.toMap(),
      'mobile': mobile,
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      chatUserId: ChatUserId.fromMap(map['chatUserId'] as Map<String,dynamic>),
      mobile: map['mobile'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) => ChatUser.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ChatUser.empty()=> ChatUser(chatUserId: ChatUserId.empty(), mobile: "");
  
}
