import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SendMessageModel {
  String message;
  String senderId;
  List<String> receiversIdSet;
  String category;
  String time;
  SendMessageModel({
    required this.message,
    required this.senderId,
    required this.receiversIdSet,
    required this.category,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'senderId': senderId,
      'receiversIdSet': receiversIdSet,
      'category': category,
      'time': time,
    };
  }

  factory SendMessageModel.fromMap(Map<String, dynamic> map) {
    return SendMessageModel(
      message: map['message'] != null ? map['message'] as String : "",
      senderId: map['senderId'] != null ? map['senderId'] as String : "",
      receiversIdSet: map['receiversIdSet'] != null 
          ? ((map['receiversIdSet']) as List<dynamic>).map((e) => e.toString()).toList()
          : [],
      category: map['category'] != null ? map['category'] as String : "",
      time: map['time'] != null ? map['time'] as String : "",
    );
  }

  List<String> toStringList(List<dynamic> lst) {
    return lst.map((e) => e.toString()).toList();
  }

  String toJson() => json.encode(toMap());

  factory SendMessageModel.fromJson(String source) =>
      SendMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
