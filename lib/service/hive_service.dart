import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/services.dart' show rootBundle;
import 'package:spordee_messaging_app/model/chat_user_model.dart';
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
      receiversIdSet: reader.readList().cast<ChatUserModel>(),
      category: reader.readString(),
      time: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer.writeDouble(obj.messageId);
    writer.writeString(obj.message);
    writer.writeString(obj.sendersId);
    writer.writeList(obj.receiversIdSet);
    writer.writeString(obj.category);
    writer.writeString(obj.time);
  }
}

