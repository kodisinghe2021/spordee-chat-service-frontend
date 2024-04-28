import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';
import 'package:spordee_messaging_app/screens/registration_screen.dart';
import 'package:spordee_messaging_app/util/constant.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SizedBox(
        width: w(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _username,
                decoration: dec("username"),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _password,
                decoration: dec("password"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
               await Provider.of<AuthenticationProvider>(context, listen: false).login(mobile: _username.text);
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegistrationScreen(),
                    ),
                  );
                },
                child: const Text("Signin here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
