import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class RouteProvider extends ChangeNotifier {
  RouteProvider._internal();
  static final RouteProvider _instance = RouteProvider._internal();
  factory RouteProvider() => _instance;

  Routes _currentPage = Routes.def;

  void navigatTo(Routes route) {
    _currentPage = route;
    notifyListeners();
    Logger().d("Route change :: >> ${_currentPage.name}");
  }

  Routes get currentRoute => _currentPage;
}

enum Routes {
  def,
  toChatScreen,
  tohomeScreen,
}
