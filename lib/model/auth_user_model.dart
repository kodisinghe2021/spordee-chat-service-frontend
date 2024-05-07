import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class AuthUserModel {
  String userId;
  String name;
  String mobile;
  String deviceId;
  AuthUserModel({
    required this.userId,
    required this.name,
    required this.mobile,
    required this.deviceId,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'mobile': mobile,
      'deviceId': deviceId,
    };
  }

  factory AuthUserModel.fromMap(Map<String, dynamic> map) {
    return AuthUserModel(
      userId: map['userId'].toString(),
      name: map['name'].toString(),
      mobile: map['mobile'].toString(),
      deviceId: map['deviceId'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthUserModel.fromJson(String source) => AuthUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
