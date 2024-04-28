import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/auth_user_model.dart';
import 'package:spordee_messaging_app/repositories/user_repo.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/keys.dart';

class AuthenticationProvider extends ChangeNotifier {
  AuthenticationProvider._internal();
  static final AuthenticationProvider _instance =
      AuthenticationProvider._internal();
  factory AuthenticationProvider() => _instance;

  final Logger log = Logger();
  final LocalStore _localStore = LocalStore();
  final UserRepo _userRepo = UserRepo();

  AuthState _authStatus = AuthState.loading;

  AuthState get getAuthStatus => _authStatus;

  void setAuthStatus(AuthState authState) {
    _authStatus = authState;
    notifyListeners();
  }

  Future<void> authenticate() async {
    String? userId = await _localStore.getFromLocal(Keys.userId);
    if (userId != null) {
      log.i("User NOT NULL $userId");
      // AuthUserModel? model = await _registrationRepo.getUser(userId);
      // log.i("Model found:: ${model!.userId.toString()}");
      await Future.delayed(const Duration(milliseconds: 2000));

      setAuthStatus(AuthState.success);
      return;
    } else {
      await Future.delayed(const Duration(milliseconds: 2000));

      setAuthStatus(AuthState.failed);
      return;
    }
  }

  Future<void> logout() async {
    bool isSuccess = await _localStore.clearStorage();
    if (isSuccess) {
      setAuthStatus(AuthState.failed);
    } else {
      setAuthStatus(AuthState.success);
    }
  }

  Future<void> login({
    required String mobile,
  }) async {
    AuthUserModel? model = await _userRepo.login(mobile: mobile);

    if (model != null) {
      await _localStore.addToLocal(Keys.userId, model.userId);
      await authenticate();
      return;
    }else{
      await authenticate();
    }
  }
}

enum AuthState { loading, success, failed }
