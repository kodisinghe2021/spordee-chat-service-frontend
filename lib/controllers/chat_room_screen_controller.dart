import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/config/creat_room_listner.dart';
import 'package:spordee_messaging_app/model/chat_user_model.dart';
import 'package:spordee_messaging_app/model/message_model.dart';
import 'package:spordee_messaging_app/repositories/chat_room_repo.dart';
import 'package:spordee_messaging_app/repositories/message_repo.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/constant.dart';
import 'package:spordee_messaging_app/util/keys.dart';

class ChatRoomScreenController with ChangeNotifier {
//==================== make singleton
  ChatRoomScreenController._internal();
  static final ChatRoomScreenController _instance =
      ChatRoomScreenController._internal();
  factory ChatRoomScreenController() => _instance;

//==================== DI
  final Logger _l = Logger();
  final LocalStore _localStore = LocalStore();
  final MessageRepo _messageRepo = MessageRepo();
  final ChatRoomRepo _chatRoomRepo = ChatRoomRepo();
  final ScrollController scrollController = ScrollController();
  // 1. give all messages accroding to the chatRoomId getting from the local
  // 2. get all offline messages from the db
  // 3. insert all offline messages to the local

//==================== OBSERVABLE VALUES
// on memory messages
  List<MessageModel> _onMemoryMessagesList = [];

  // add message to the on memory
  void addMessageToOnMemory(MessageModel messageModel) {
    // insert to the index 0 -- LIFO
    _onMemoryMessagesList.add(messageModel);
    notifyListeners();
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 65,
        duration: const Duration(milliseconds: 600),
        curve: Curves.bounceOut,
      );
    }
  }

  // add message List to the on memory
  void addMessageListToOnMemory(List<MessageModel> messageModels) {
    // insert to the index 0 -- LIFO
    for (var item in messageModels) {
      _onMemoryMessagesList.add(item);
    }
    notifyListeners();
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 65,
        duration: const Duration(milliseconds: 600),
        curve: Curves.bounceOut,
      );
    }
  }

  // send all onmemory messages to the requester
  List<MessageModel> get getOnMemoryMessages => [..._onMemoryMessagesList];

// chatRoom Users List
  List<ChatUserModel> _usersListAtRoom = [];

  void addUsersListToRoom(List<ChatUserModel> list) {
    _usersListAtRoom = list;
    notifyListeners();
  }

  List<ChatUserModel> get usersListInRoom => _usersListAtRoom;

  // chatRoom Users List
  List<MessageModel> _offlineMessages = [];

  void addOfflineMessages(List<MessageModel> list) {
    _offlineMessages = list;
  }

  List<MessageModel> get getOfflineMessages => _offlineMessages;

  int offlineMessageCount = 0;
  String roomId = "";
//==================== LOCAL STORING
// put message to local
  Future<void> putToLocal(String roomId, MessageModel messageModel) async {
    var box = await Hive.openBox<MessageModel>(roomId);

    // insert to first
    await box.add(messageModel);
  }

// get messages from local
  Future<List<MessageModel>> getMessages(String roomId) async {
    Logger().e("ROOM ID ::: $roomId");
    try {
      var box = await Hive.openBox<MessageModel>(roomId);
      // To retrieve your SendMessageModel objects
      List<MessageModel> savedMessages = box.values.toList();
      return savedMessages;
    } catch (e) {
      return [];
    }
  }

//==================== Message Handling receive/send
// when a new message received first add it to the onMemory list, then add to the local
  Future<void> newMessageReceived(
      Map<String, dynamic> payload, String roomId) async {
    // convert payload
    try {
      MessageModel messageModel = MessageModel.fromMap(payload);

      // set to the onMemory
      addMessageToOnMemory(messageModel);

      // check this message from User added state
      if (messageModel.category == MessageCategory.JOIN.name) {
        _l.e(
            "User added to the room. new List : ${messageModel.receiversIdSet}");
        addUsersListToRoom(messageModel.receiversIdSet);
      }

      // set to Local
      await putToLocal(roomId, messageModel);

      _l.i("Converted");
    } catch (e) {
      _l.e("Converting error");
    }
  }

// send Message
  Future<void> sendPublicMessage() async {
    Future<void> sendPublicMessage({required String message}) async {
      String? userId = await _localStore.getFromLocal(Keys.userId);
      String? roomId = await _localStore.getFromLocal(Keys.roomId);
      String? deviceId = await _localStore.getFromLocal(Keys.deviceId);
      if (userId == null || roomId == null || deviceId == null) {
        _l.w("Some Value NULL");
        return;
      }
      await _messageRepo.sendPublicMessage(
        message: message,
        userId: userId,
        roomUsers: usersListInRoom,
        category: MessageCategory.PUBLIC,
        roomId: roomId,
        deviceId: deviceId,
      );
    }
  }

  //==================== Initilizing Chat room
  Future<void> initChatRoom(String roomId) async {
    roomId = roomId;
    await getUsersList(roomId: roomId);
    await refreshMessages(roomId);
    offlineMessageCount = await loadAllOfflineMessages(roomId);
    await activeChatRoom();
  }

// first load the room members list
  Future<void> getUsersList({
    required String roomId,
  }) async {
    if (roomId.isEmpty) {
      return;
    }

    _l.i("Chat RoomId : $roomId");
    List<ChatUserModel> users = await _chatRoomRepo.getUsersList(
      roomId: roomId,
    );
    addUsersListToRoom(users);
    _l.i("New Users List ADDED TO CHAT: ${usersListInRoom.length}");
  }

// load the offline messages
  Future<int> loadAllOfflineMessages(String roomId) async {
    String? userId = await _localStore.getFromLocal(Keys.userId);
    String? deviceId = await _localStore.getFromLocal(Keys.deviceId);

    if (userId == null) {
      _l.w("userId null");
      return -1;
    }
    if (deviceId == null) {
      _l.w("deviceId null");
      return -1;
    }
    if (roomId.isEmpty) {
      _l.w("roomId empty");
      return -1;
    }

    List<MessageModel> messages =
        await _messageRepo.getOfflineMessages(userId, roomId, deviceId);

    _l.d("List Caught from provider  ${messages.length}");
    _l.d("List Caught from provider  $messages");

    // save messages to localStore
    if (messages.isNotEmpty) {
      for (var item in messages) {
        await putToLocal(roomId, item);
      }
      // and add to onMemory
      addOfflineMessages(messages);
      await _messageRepo.removeOfflineMessages(userId, roomId, deviceId);
    }
    return messages.length;
  }

  void addOflineMessagesToOnMemoryList() {
    addMessageListToOnMemory(getOfflineMessages);
    offlineMessageCount = 0;
  }

// reshresh the list, get from local and add to the onMemory
  Future<void> refreshMessages(String roomId) async {
    List<MessageModel> messages = await getMessages(roomId);
    // TODO: remove all prevoius messages, unttil last 10
    // ***************
    if (messages.length > 10) {
      messages =
          messages.getRange(messages.length - 10, messages.length).toList();
    }
    addMessageListToOnMemory(messages);
    _l.w(
        "Refresh room -->> triggered onmemory message count :: ${getOnMemoryMessages.length}");
    notifyListeners();
  }

// ==== distroy room
  Future<void> distroyRoom() async {
    disconnectChatRoom();
    _onMemoryMessagesList.clear();
    _usersListAtRoom.clear();
    offlineMessageCount = 0;
    roomId = "";
  }
}
