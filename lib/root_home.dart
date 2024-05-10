import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';
import 'package:spordee_messaging_app/controllers/chat/room_provider.dart';
import 'package:spordee_messaging_app/controllers/chat_room_screen_controller.dart';
import 'package:spordee_messaging_app/controllers/messages/message_provider.dart';
import 'package:spordee_messaging_app/controllers/messages/room_page_meesage_list.dart';
import 'package:spordee_messaging_app/controllers/route_controller.dart';
import 'package:spordee_messaging_app/screens/chat_room.dart';
import 'package:spordee_messaging_app/screens/home_screen.dart';
import 'package:spordee_messaging_app/screens/login_screen.dart';
import 'package:spordee_messaging_app/screens/splash_screen.dart';

class RootHome extends StatelessWidget {
  const RootHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthenticationProvider>(
            create: (context) => AuthenticationProvider(),
          ),
          ChangeNotifierProvider<RoomProvider>(
            create: (context) => RoomProvider(),
          ),
          ChangeNotifierProvider<MessageProvider>(
            create: (context) => MessageProvider(),
          ),
          ChangeNotifierProvider<RoomPageMessageList>(
            create: (context) => RoomPageMessageList(),
          ),
          ChangeNotifierProvider<ChatRoomScreenController>(
            create: (context) => ChatRoomScreenController(),
          ),
          ChangeNotifierProvider<RouteProvider>(
            create: (context) => RouteProvider(),
          ),
        ],
        child: Consumer<AuthenticationProvider>(
          builder: (context, value, child) {
            if (value.getAuthStatus == AuthState.failed) {
              return LoginScreen();
            }
            if (value.getAuthStatus == AuthState.success) {
              return Consumer<RouteProvider>(
                builder: (context, value, child) {
                  Logger().d("new Route :: ${value.currentRoute}");
                  if (value.currentRoute == Routes.toChatScreen) {
                    return const ChatRoomScreen();
                  }
                  if (value.currentRoute == Routes.tohomeScreen) {
                    return HomeScreen();
                  }
                  return HomeScreen();
                },
              );
            } else {
              return const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
