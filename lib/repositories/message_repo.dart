import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/model/chat_room_model.dart';
import 'package:spordee_messaging_app/model/chat_user_model.dart';
import 'package:spordee_messaging_app/model/send_message_model.dart';
import 'package:spordee_messaging_app/util/constant.dart';
import 'package:spordee_messaging_app/util/dio_initilizer.dart';
import 'package:spordee_messaging_app/util/dotenv.dart';

class MessageRepo {
  final DioInit _dioInit = DioInit();
  final Logger _log = Logger();

  Future<void> sendPublicMessage({
    required String message,
    required String userId,
    required String deviceId,
    required List<ChatUserModel> roomUsers,
    required MessageCategory category,
    required String roomId,
  }) async {
    SendMessageModel model = SendMessageModel(
      messageId: -1,
      message: message,
      senderId: ChatUserModel(id: userId, deviceId:deviceId),
      receiversIdSet: roomUsers,
      category: category.name,
      time: "",
    );

    try {
      final response = await _dioInit.dioInit.post(
        sendMessagePath(roomId),
        data: model.toMap(),
      );

      _log.i("Reponse CODE:::: ${response.statusCode}");
    } on DioException catch (e) {
      _log.e("DIO ERROR :: ${e.error}");
    } catch (e) {
      _log.e("ERROR :: $e");
    }
  }

  Future<List<SendMessageModel>> getOfflineMessages(
    String userId,
    String roomId,
  ) async {
    Response response =
        await _dioInit.dioInit.get(getOfflineMessagePath(userId, roomId));
    _log.i(response.data);
    _log.i(response.data.runtimeType);

    if (response.data.toString().isEmpty) {
      return [];
    }

    List<dynamic> dyList = response.data as List<dynamic>;
    List<Map<String, dynamic>> mapList =
        dyList.map((e) => e as Map<String, dynamic>).toList();

    _log.d(mapList.runtimeType);
    List<SendMessageModel> lst = [];

    for (var item in mapList) {
      _log.d("ITEM TYPE :::${item.runtimeType}");
      lst.add(SendMessageModel.fromMap(item));
    }
    _log.d("model list created  ${lst.length}");
    return lst;
  }

  Future<List<SendMessageModel>> getPaginatedMessages({
    required String userId,
    required String roomId,
    required int page,
    required int size,
  }) async {
    Response response = await _dioInit.dioInit.get(
      getOfflineMessagePath(userId, roomId),
      queryParameters: {
        "page": page,
        "size": size,
      },
    );
    _log.i(response.data);

    if (response.data.toString().isEmpty) {
      return [];
    }

    List<dynamic> dyList = response.data as List<dynamic>;
    List<Map<String, dynamic>> mapList =
        dyList.map((e) => e as Map<String, dynamic>).toList();

    List<SendMessageModel> lst = [];

    for (var item in mapList) {
      lst.add(SendMessageModel.fromMap(item));
    }
    for (var item in lst) {
    _log.d("model list created  ${item.message}");
      
    }
    return lst;
  }
}
