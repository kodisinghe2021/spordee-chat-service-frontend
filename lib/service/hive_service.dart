import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/services.dart' show rootBundle;
import 'package:spordee_messaging_app/model/v2/chat_user_id_model.dart';
import 'dart:async';
import 'dart:convert';

import 'package:spordee_messaging_app/model/message_model.dart';

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 0;

  @override
  MessageModel read(BinaryReader reader) {
    return MessageModel(
      messageId: reader.readDouble(),
      message: reader.readString(),
      sendersId: reader.readString(),
      chatUserIdSet:[], // reader.readList().cast<ChatUserId>(),
      messageCategory: reader.readString(),
      sentTime: reader.readString(),
      chatRoomId: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer.writeDouble(obj.messageId);
    writer.writeString(obj.message);
    writer.writeString(obj.sendersId);
    // writer.writeList(obj.chatUserIdSet);
    writer.writeList([]);
    writer.writeString(obj.messageCategory);
    writer.writeString(obj.sentTime);
    writer.writeString(obj.chatRoomId);
  }
}
