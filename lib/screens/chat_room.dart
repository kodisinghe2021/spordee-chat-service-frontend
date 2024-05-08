import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spordee_messaging_app/config/creat_room_listner.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';
import 'package:spordee_messaging_app/controllers/chat/room_provider.dart';
import 'package:spordee_messaging_app/controllers/messages/message_provider.dart';
import 'package:spordee_messaging_app/controllers/messages/room_page_meesage_list.dart';
import 'package:spordee_messaging_app/controllers/route_controller.dart';
import 'package:spordee_messaging_app/model/chat_user_model.dart';
import 'package:spordee_messaging_app/util/constant.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _message = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  Future<bool> back() async {
    RoomPageMessageList().clearMessages();
    return true;
  }

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            Logger().i("Tapped");
            RoomPageMessageList().clearMessages();
            //  AuthenticationProvider().authenticate();
            await disconnectChatRoom();
            RouteProvider().navigatTo(Routes.tohomeScreen);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Chat Room"),
      ),
      body: SizedBox(
        height: h(context),
        width: w(context),
        child: Column(
          children: [
            Consumer<RoomPageMessageList>(builder: (_, value, child) {
              return Expanded(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  controller: Provider.of<RoomPageMessageList>(context)
                      .scrollController,
                  itemCount: value.messages.length < 10
                      ? value.messages.length
                      : value.messages.length + 1,
                  itemBuilder: (context, index) {
                    final sc =
                        Provider.of<RoomPageMessageList>(context, listen: false)
                            .scrollController;
                    sc.addListener(() {
                      if (sc.position.maxScrollExtent == sc.offset) {
                        Logger().e("EEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
                        Provider.of<MessageProvider>(context, listen: false)
                            .setPage(true);
                        Provider.of<MessageProvider>(context, listen: false)
                            .getMessagesWithPage();
                      }
                      // if (sc.position.minScrollExtent == sc.offset) {
                      //   Logger().e("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                      //   Provider.of<MessageProvider>(context, listen: false).setPage(false);
                      //   Provider.of<MessageProvider>(context, listen: false)
                      //       .getMessagesWithPage();
                      // }
                    });
                    if (value.messages.isEmpty) {
                      return const Center(child: Text("No messages to show"));
                    }
                    return index < value.messages.length
                        ? ListTile(
                            title: Text(value.messages[index].message),
                            subtitle: Text(value.messages[index].time),
                          )
                        : const CupertinoActivityIndicator();
                  },
                ),
              );
            }),
            Container(
              height: h(context) * .1,
              width: w(context),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _message,
                      decoration: dec("Type your message.."),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        isLoading.value = true;
                        //  TODO: Message sending ui
                        List<ChatUserModel> roomUsers = RoomProvider().usersList;
                        Logger().w("USERS : ${roomUsers.toString()}");
                        await MessageProvider().sendPublicMessage(
                          message: _message.text,
                          roomUsers: roomUsers,
                        );
                        _message.clear();
                        isLoading.value = false;
                      },
                      icon: ValueListenableBuilder<bool>(
                        valueListenable: isLoading,
                        builder: (context, value, child) => value
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    ;
  }
}
