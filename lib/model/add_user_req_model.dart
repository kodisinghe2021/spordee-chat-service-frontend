import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddUserRequestModel {
   String newUserId;
   String newUserDeviceId;
   String chatRoomId;
   String adminId;
   String adminDeviceId;
  AddUserRequestModel({
    required this.newUserId,
    required this.newUserDeviceId,
    required this.chatRoomId,
    required this.adminId,
    required this.adminDeviceId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'newUserId': newUserId,
      'newUserDeviceId': newUserDeviceId,
      'chatRoomId': chatRoomId,
      'adminId': adminId,
      'adminDeviceId': adminDeviceId,
    };
  }

  
}
