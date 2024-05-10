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
import 'package:spordee_messaging_app/model/message_model.dart';
import 'package:spordee_messaging_app/screens/chat_room.dart';
import 'package:spordee_messaging_app/service/hive_service.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/constant.dart';
import 'package:spordee_messaging_app/util/exceptions.dart';
import 'package:spordee_messaging_app/util/keys.dart';
import 'package:spordee_messaging_app/widgets/bottom_sheet_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _roomName = TextEditingController();
  final ValueNotifier<bool> isLoadingA = ValueNotifier(false);
  final ValueNotifier<bool> isLoadingGetRoomList = ValueNotifier(false);

  // //=== before navigate to the chat room the data set must be inizilized
  // Future<bool> setupChatRoom(String roomId) async {
  //   try {
  //     //1. -- save roomId to local
  //     bool isLocalStoreSuucess =
  //         await LocalStore().addToLocal(Keys.roomId, roomId);

  //     //2. -- get the users list
  //     if (roomId.isNotEmpty && isLocalStoreSuucess) {
  //       await Provider.of<RoomProvider>(
  //         context,
  //         listen: false,
  //       ).getUsersList(roomId: roomId);

  //       //TODO: 3. get the OfflineMessages and save on memory
  //       //TODO: 4. Load the all offline messages

  //       // need to load all messages in this room from the local
  //       await Provider.of<RoomPageMessageList>(context, listen: false)
  //           .addToOnMemoryFromLocal(roomId);

  //       bool isSuccess = await activeChatRoom();
  //       // get all offline messages
  //       await Provider.of<MessageProvider>(context, listen: false)
  //           .getOfflineMessages(roomId: roomId);
  //       // await Provider.of<MessageProvider>(
  //       //   context,
  //       //   listen: false,
  //       // ).getMessagesWithPage();
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              await Provider.of<AuthenticationProvider>(context, listen: false)
                  .logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: w(context),
          child: Column(
            children: [
              Consumer<RoomProvider>(
                builder: (context, value, child) {
                  if (value.getChatRooms.isEmpty) {
                    return SizedBox();
                  }
                  return SizedBox(
                    height: value.getChatRooms.length < 2
                        ? h(context) * .1
                        : h(context) * .2,
                    width: w(context),
                    child: ListView.builder(
                      itemCount: value.getChatRooms.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<String?>(
                          future: LocalStore().getFromLocal(Keys.userId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListTile(
                                leading: IconButton(
                                  onPressed: () async {
                                   await Provider.of<ChatRoomScreenController>(
                                            context, listen: false)
                                        .initChatRoom(value.getChatRooms[index]
                                            .publicChatRoomId);
                                    Provider.of<RouteProvider>(
                                      context,
                                      listen: false,
                                    ).navigatTo(Routes.toChatScreen);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                title: Text(
                                    "name: ${value.getChatRooms[index].publicChatRoomName}"),
                                trailing: snapshot.data ==
                                        value.getChatRooms[index].createdBy
                                    ? TextButton(
                                        onPressed: () {
                                          Scaffold.of(context).showBottomSheet(
                                            (context) => BottomSheetForm(
                                              room: value.getChatRooms[index],
                                            ),
                                          );
                                          //  Provider.of<RoomProvider>(context, listen: false).addMember( value.getChatRooms[index].id);
                                        },
                                        child: const Text("Add friend"),
                                      )
                                    : null,
                              );
                            }
                            return const CupertinoActivityIndicator();
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: h(context) * .06,
                width: w(context),
                child: TextFormField(
                  controller: _roomName,
                  decoration: dec("Chat Room name"),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: h(context) * .06,
                    width: w(context) * .4,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isLoadingGetRoomList,
                      builder: (context, value, child) => value
                          ? const CupertinoActivityIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                isLoadingGetRoomList.value = true;
                                bool isCaught = await Provider.of<RoomProvider>(
                                  context,
                                  listen: false,
                                ).getAllRooms();
                                if (!isCaught) {
                                  showWarningToast("No Rooms");
                                }
                                isLoadingGetRoomList.value = false;
                              },
                              child: const Text("Get Room List"),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: h(context) * .06,
                    width: w(context) * .4,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isLoadingA,
                      builder: (context, value, child) => value
                          ? const CupertinoActivityIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                isLoadingA.value = true;
                                bool isSuccess =
                                    await Provider.of<RoomProvider>(context,
                                            listen: false)
                                        .createChatRoom(name: _roomName.text);
                                isLoadingA.value = false;
                                if (!isSuccess) {
                                  showWarningToast(
                                      ExceptionMessage().errorMessage);
                                }
                              },
                              child: const Text("Create Chat Room"),
                            ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () async {
              //     // await saveMessages(
              //     //   "a",
              //     //   SendMessageModel(
              //     //     messageId: 1,
              //     //     message: "BBBBB",
              //     //     sendersId: "sendersId",
              //     //     receiversIdSet: [],
              //     //     category: "PUBLIC",
              //     //     time: "time",
              //     //   ),
              //     // );
              //   },
              //   child: Text("Add to local"),
              // ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () async {
              //     // List<SendMessageModel> models = await getMessages("a");
              //     // for (var item in models) {
              //     //   Logger().i("model::: ${item.message}");
              //     // }
              //   },
              //   child: Text("Retrieve from local"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
