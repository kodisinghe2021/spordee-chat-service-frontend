import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spordee_messaging_app/controllers/authentication/authentication_provider.dart';
import 'package:spordee_messaging_app/screens/registration_screen.dart';
import 'package:spordee_messaging_app/util/constant.dart';
import 'package:spordee_messaging_app/util/exceptions.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final ValueNotifier<bool> _isLoadingA = ValueNotifier(false);
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
             const SizedBox(height: 10),
              TextFormField(
                controller: _password,
                decoration: dec("password"),
              ),
             const SizedBox(height: 20),
              ValueListenableBuilder<bool>(
                valueListenable: _isLoadingA,
                builder: (context, value, child) => value
                    ? const CupertinoActivityIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          Logger().d("Login click");
                          _isLoadingA.value = true;
                          await Provider.of<AuthenticationProvider>(context,
                                  listen: false)
                              .login(mobile: _username.text);
                          _isLoadingA.value = false;
                          showWarningToast(ExceptionMessage().errorMessage);
                        },
                        child: const Text("Login"),
                      ),
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
