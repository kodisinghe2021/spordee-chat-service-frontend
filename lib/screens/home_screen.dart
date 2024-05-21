import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';
import 'package:spordee_messaging_app/controllers/room_provider.dart';
import 'package:spordee_messaging_app/controllers/chat_room_screen_controller.dart';
import 'package:spordee_messaging_app/controllers/private_chat_room.dart';
import 'package:spordee_messaging_app/controllers/route_controller.dart';
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
  final TextEditingController _privateUserB = TextEditingController();
  final ValueNotifier<bool> isLoadingA = ValueNotifier(false);
  final ValueNotifier<bool> privateChatRoomLoading = ValueNotifier(false);
  final ValueNotifier<bool> isLoadingGetRoomList = ValueNotifier(false);
  final ValueNotifier<bool> isLoadingGetRoom = ValueNotifier(false);

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
                    return const SizedBox();
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
                                            context,
                                            listen: false)
                                        .initChatRoom(value
                                            .getChatRooms[index].chatRoomId);
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
                                    "name: ${value.getChatRooms[index].roomName}"),
                                trailing: snapshot.data ==
                                        value.getChatRooms[index].createdBy
                                            .chatUserId
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
              SizedBox(height: 20),
              //================= private chat ===========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: h(context) * .06,
                    width: w(context) * .55,
                    child: TextFormField(
                      controller: _privateUserB,
                      decoration: dec("Enter Mobile Number"),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: h(context) * .06,
                    width: w(context) * .3,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: privateChatRoomLoading,
                      builder: (context, value, child) => value
                          ? const CupertinoActivityIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                privateChatRoomLoading.value = true;
                                bool isSuccess = await Provider.of<
                                    PrivateChatRoomController>(
                                  context,
                                  listen: false,
                                ).createNewPrivateChat(
                                    userName: _privateUserB.text);
                                privateChatRoomLoading.value = false;
                              },
                              child: const Text("Chat"),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: h(context) * .06,
                width: w(context) * .4,
                child: ValueListenableBuilder<bool>(
                  valueListenable: isLoadingGetRoom,
                  builder: (context, value, child) => value
                      ? const CupertinoActivityIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            isLoadingGetRoom.value = true;
                            bool isCaught = await Provider.of<RoomProvider>(
                              context,
                              listen: false,
                            ).getAllRooms();
                            if (!isCaught) {
                              showWarningToast("No Friends");
                            }
                            isLoadingGetRoom.value = false;
                          },
                          child: const Text("Get Friend List"),
                        ),
                ),
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
