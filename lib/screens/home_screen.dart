import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spordee_messaging_app/config/creat_room_listner.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';
import 'package:spordee_messaging_app/controllers/chat/room_provider.dart';
import 'package:spordee_messaging_app/screens/chat_room.dart';
import 'package:spordee_messaging_app/service/local_store.dart';
import 'package:spordee_messaging_app/util/constant.dart';
import 'package:spordee_messaging_app/util/keys.dart';
import 'package:spordee_messaging_app/widgets/bottom_sheet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _roomName = TextEditingController();
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
                                    // save roomId to local
                                    String roomId =
                                        value.getChatRooms[index].chatRoomId;
                                    bool isSuucess = await LocalStore()
                                        .addToLocal(Keys.roomId, roomId);
                                    if (roomId.isNotEmpty && isSuucess) {
                                      Provider.of<RoomProvider>(context, listen: false).getUsersList(roomId: roomId);
                                      bool isSuccess = await activeChatRoom();
                                      if (isSuccess) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                              const  ChatRoomScreen(),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                title: Text(
                                    "name: ${value.getChatRooms[index].name}"),
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
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<RoomProvider>(context, listen: false)
                            .getAllRooms();
                      },
                      child: const Text("Get Room List"),
                    ),
                  ),
                  SizedBox(
                    height: h(context) * .06,
                    width: w(context) * .4,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<RoomProvider>(context, listen: false)
                            .createChatRoom(name: _roomName.text);
                      },
                      child: const Text("Create Chat Room"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
