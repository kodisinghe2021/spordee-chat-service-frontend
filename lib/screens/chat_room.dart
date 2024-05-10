import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spordee_messaging_app/config/creat_room_listner.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';
import 'package:spordee_messaging_app/controllers/chat/room_provider.dart';
import 'package:spordee_messaging_app/controllers/chat_room_screen_controller.dart';
import 'package:spordee_messaging_app/controllers/messages/message_provider.dart';
import 'package:spordee_messaging_app/controllers/messages/room_page_meesage_list.dart';
import 'package:spordee_messaging_app/controllers/route_controller.dart';
import 'package:spordee_messaging_app/model/chat_user_model.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/constant.dart';
import 'package:spordee_messaging_app/util/keys.dart';

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
            Provider.of<ChatRoomScreenController>(context, listen: false)
                .distroyRoom();
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
            Consumer<ChatRoomScreenController>(builder: (_, value, child) {
              return Expanded(
                child: ListView.builder(
                  // reverse: true,
                  shrinkWrap: true,
                  controller: Provider.of<ChatRoomScreenController>(context)
                      .scrollController,
                  itemCount: value.offlineMessageCount <= 0
                      ? value.getOnMemoryMessages.length
                      : value.getOnMemoryMessages.length + 1,
                  itemBuilder: (context, index) {
                    final sc = Provider.of<ChatRoomScreenController>(context,
                            listen: false)
                        .scrollController;
                    sc.addListener(() {
                      // if (sc.position.maxScrollExtent == sc.offset) {
                      //   Logger().e("EEEEEEEEEEEEEEEEEEEEEEEEEEEEE");

                      //   // Provider.of<MessageProvider>(context, listen: false)
                      //   //     .setPage(true);
                      //   // Provider.of<MessageProvider>(context, listen: false)
                      //   //     .getMessagesWithPage();
                      // }

                      // if (sc.position.minScrollExtent == sc.offset) {
                      //   // Logger().e("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                      //   // Provider.of<MessageProvider>(context, listen: false)
                      //   //     .setPage(false);
                      //   // Provider.of<MessageProvider>(context, listen: false)
                      //   //     .getMessagesWithPage();
                      // }

                    });
                    if (value.getOnMemoryMessages.isEmpty) {
                      return const Center(child: Text("No messages to show"));
                    }
                    if (index < value.getOnMemoryMessages.length) {
                      return ListTile(
                        title: Text(value.getOnMemoryMessages[index].message),
                        subtitle: Text(value.getOnMemoryMessages[index].time),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () async{
                         String? roomId = await LocalStore().getFromLocal(Keys.roomId);
                         if(roomId != null){
                          Provider.of<ChatRoomScreenController>(context, listen: false).addOflineMessagesToOnMemoryList();
                         
                         }
                        },
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.2),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                  "You have new ${value.offlineMessageCount} messages"),
                            ),
                          ),
                        ),
                      );
                    }
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
                        List<ChatUserModel> roomUsers =
                            RoomProvider().usersList;
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
