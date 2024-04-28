import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spordee_messaging_app/controllers/authentication/registration_controller.dart';
import 'package:spordee_messaging_app/util/constant.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key? key}) : super(key: key);
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();

  bool isLoading = false;
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
                controller: _userName,
                decoration: dec("you name"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mobileNumber,
                decoration: dec("mobile number"),
              ),
              const SizedBox(height: 20),
              if (isLoading) ...{
                const CupertinoActivityIndicator(),
              } else ...{
                ElevatedButton(
                  onPressed: () async {
                    Logger().i("Tapped");
                    bool isSuccess = await RegistrationController().register(
                      name: _userName.text,
                      mobile: _mobileNumber.text,
                    );
                    if (isSuccess) {
                      Navigator.pop(context);
                    } else {}
                  },
                  child: const Text("Register"),
                ),
              },
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text("Go To Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
