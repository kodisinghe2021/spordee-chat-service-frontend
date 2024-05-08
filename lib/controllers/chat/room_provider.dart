import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/auth_user_model.dart';
import 'package:spordee_messaging_app/model/chat_room_model.dart';
import 'package:spordee_messaging_app/model/chat_user_model.dart';
import 'package:spordee_messaging_app/repositories/chat_room_repo.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/keys.dart';
import 'package:device_info_plus/device_info_plus.dart';

class RoomProvider extends ChangeNotifier {
  RoomProvider._internal();
  static final RoomProvider _instance = RoomProvider._internal();
  factory RoomProvider() => _instance;

  final ChatRoomRepo _chatRoomRepo = ChatRoomRepo();
  final LocalStore _localStore = LocalStore();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Logger log = Logger();

  List<ChatRoomModel> _chatRooms = [];
  List<AuthUserModel> _userResult = [];
  List<ChatUserModel> _usersList = [];

  void addUsersList(List<ChatUserModel> list) {
    _usersList = list;
    notifyListeners();
  }

  List<ChatUserModel> get usersList => _usersList;

  void _addUSearchResult(AuthUserModel model) {
    _userResult.clear();
    _userResult.add(model);
    notifyListeners();
  }

  void clearSearchResult() {
    _userResult.clear();
    notifyListeners();
  }

  List<AuthUserModel> get getUserReult => _userResult;

  void _addChatRoom(ChatRoomModel model) {
    _chatRooms.add(model);
    notifyListeners();
  }

  void _replaceRooms(List<ChatRoomModel> models) {
    _chatRooms = models;
    notifyListeners();
  }

  List<ChatRoomModel> get getChatRooms => [..._chatRooms];

  Future<bool> createChatRoom({
    required String name,
  }) async {
    final baseDeviceInfo = await _deviceInfo.deviceInfo;
    log.d("Base device info: ${baseDeviceInfo.toMap.toString()}");
    AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
    String? deviceID = androidInfo.fingerprint;
    String? userId = await _localStore.getFromLocal(Keys.userId);
    log.d("USER ID :: ${userId.toString()}");
    log.d("DEVICE ID :: ${deviceID.toString()}");

    if (userId == null || deviceID == null) {
      log.w("User NULL");
      return false;
    }
    log.d("android id : $deviceID");
    ChatRoomModel? model = await _chatRoomRepo.createChatRoom(
      id: "",
      name: name,
      description: "default description",
      createdBy: userId,
      deviceId: deviceID,
    );
    if (model != null) {
      _addChatRoom(model);
      return true;
    } else {
      log.w("No model added at this time");
      return false;
    }
  }

  Future<bool> getAllRooms() async {
    String? userId = await _localStore.getFromLocal(Keys.userId);
    String? deviceId = await _localStore.getFromLocal(Keys.deviceId);

    if (userId == null) {
      log.w("User NULL");
      return false;
    }

    if (deviceId == null) {
      log.w("DeviceID NULL");
      return false;
    }
    log.d("USER ID :: ${userId.toString()}");
    log.d("DEVICE ID :: ${deviceId.toString()}");

    List<ChatRoomModel> models =
        await _chatRoomRepo.getAllRooms(userId: userId, deviceId: deviceId);
        
    log.i("NEW MODELS RECEIVED :: ${models.length}");
    _replaceRooms(models);
    if (models.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> findMemberByMobile(String mobile) async {
    AuthUserModel? model = await _chatRoomRepo.findByMobile(mobile);
    if (model == null) {
      return false;
    }
    _addUSearchResult(model);
    return true;
  }

  Future<bool> addUser({
    required String room,
    required String memberId,
    required String memberDeviceId,
  }) async {
    log.i("Chat RoomId : $room");
    log.i("Member : $memberId");
    String? userId = await _localStore.getFromLocal(Keys.userId);
    String? deviceId = await _localStore.getFromLocal(Keys.deviceId);

    log.d("USER ID :: ${userId.toString()}");

    if (userId == null) {
      log.w("User NULL");
      return false;
    }

    if (deviceId == null) {
      log.w("DeviceID NULL");
      return false;
    }
    ChatRoomModel? chatRoomModel = await _chatRoomRepo.addUser(
      adminId: userId,
      adminDeviceId: deviceId,
      chatRoomId: room,
      newUserDeviceId: memberDeviceId,
      newUserId: memberId,
    );

    if (chatRoomModel == null) {
      Logger().d(" IN REPO MODEL NULL::");
      return false;
    } else {
      Logger().d(" IN REPO :: ${chatRoomModel.chatRoomId}");
      return true;
    }
  }

  Future<void> getUsersList({
    required String roomId,
  }) async {
    if (roomId.isEmpty) {
      return;
    }

    log.i("Chat RoomId : $roomId");
    List<ChatUserModel> users = await _chatRoomRepo.getUsersList(
      roomId: roomId,
    );
    addUsersList(users);
    log.i("New Users List ADDED TO CHAT: ${usersList.length}");
  }
}
