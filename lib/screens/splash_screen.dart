import 'package:flutter/material.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    AuthenticationProvider().authenticate();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading...."),
      ),
    );
  }
}
