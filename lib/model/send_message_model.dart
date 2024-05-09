import 'dart:convert';

import 'package:spordee_messaging_app/model/chat_user_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SendMessageModel {
  double messageId;
  String message;
  String sendersId;
  List<ChatUserModel> receiversIdSet;
  String category;
  String time;
  SendMessageModel({
    required this.messageId,
    required this.message,
    required this.sendersId,
    required this.receiversIdSet,
    required this.category,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'message': message,
      'senderId': sendersId,
      'receiversIdSet': receiversIdSet.map((x) => x.toMap()).toList(),
      'category': category,
      'time': time,
    };
  }

  factory SendMessageModel.fromMap(Map<String, dynamic> map) {
    return SendMessageModel(
      messageId: map['messageId'] != null?  double.parse(map['messageId'].toString()):-1,
      message: map['message'].toString(),
      sendersId: map['senderId'].toString(),
      receiversIdSet:map['receiversIdSet'] != null? List<ChatUserModel>.from((map['receiversIdSet'] as List<dynamic>).map<ChatUserModel>((x) => ChatUserModel.fromMap(x as Map<String,dynamic>),),):[],
      category: map['category'].toString(),
      time: map['time'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SendMessageModel.fromJson(String source) => SendMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
