import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ResponseModel {
    int code;
    String message;
    Object data;
  ResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      code: map['code'] ?? -1,
      message: map['message'].toString(),
      data: map['data']!= null? map['data'] as Object:{},
    );
  }

  // factory ResponseModel.fromJson(String source) => ResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

