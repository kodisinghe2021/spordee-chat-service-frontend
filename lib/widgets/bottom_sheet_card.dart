import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spordee_messaging_app/model/chat_room_model.dart';
import 'package:spordee_messaging_app/controllers/chat/room_provider.dart';
import 'package:spordee_messaging_app/util/constant.dart';



class BottomSheetForm extends StatelessWidget {
  BottomSheetForm({
    Key? key,
    required this.room,
  }) : super(key: key);
  final TextEditingController _mobile = TextEditingController();
  final ChatRoomModel room;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: h(context) * .2,
      width: w(context),
      decoration: const BoxDecoration(color: Colors.black38),
      child: Consumer<RoomProvider>(
        builder: (context, value, child) {
          if (value.getUserReult.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Provider.of<RoomProvider>(context).getUserReult.first.name,
                ),
                SizedBox(
                  height: h(context) * .06,
                  width: w(context) * .4,
                  child: ElevatedButton(
                    onPressed: () async {
                      Provider.of<RoomProvider>(context, listen: false).addUser(
                        room: room.chatRoomId,
                        memberId: value.getUserReult.first.userId,
                      );
                      Provider.of<RoomProvider>(context, listen: false)
                          .clearSearchResult();
                    },
                    child: const Text("Add user"),
                  ),
                ),
              ],
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _mobile,
                keyboardType: TextInputType.number,
                decoration: dec("enter user mobile"),
              ),
              SizedBox(
                height: h(context) * .06,
                width: w(context) * .4,
                child: ElevatedButton(
                  onPressed: () async {
                    await Provider.of<RoomProvider>(context, listen: false)
                        .findMemberByMobile(_mobile.text);
                  },
                  child: const Text("Search user"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
