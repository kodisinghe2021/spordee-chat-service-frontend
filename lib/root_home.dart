import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';
import 'package:spordee_messaging_app/controllers/chat/room_provider.dart';
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
        ],
        child: Consumer<AuthenticationProvider>(
          builder: (context, value, child) {
            if (value.getAuthStatus == AuthState.failed) {
              return LoginScreen();
            }
            if (value.getAuthStatus == AuthState.success) {
              return HomeScreen();
            } else {
              return SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
