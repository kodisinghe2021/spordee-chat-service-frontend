import 'package:logger/logger.dart';

class ExceptionMessage {
  ExceptionMessage._internal();
  static final ExceptionMessage _instance = ExceptionMessage._internal();
  factory ExceptionMessage() => _instance;

  String _message = "Somthing went wrong";

  void setMessage(String message) {
    _message = message;
    Logger().w("EX MESSAGE :: $_message");
  }

  String get errorMessage => _message;
}
