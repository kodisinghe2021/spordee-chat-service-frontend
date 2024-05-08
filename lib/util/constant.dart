import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

double w(BuildContext context) => MediaQuery.of(context).size.width;
double h(BuildContext context) => MediaQuery.of(context).size.height;

InputDecoration dec(String hint) => InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.grey, // Change border color as needed
          width: 2.0, // Adjust border width for desired thickness
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.blue, // Change focus border color
          width: 2.0, // Adjust border width for desired thickness
        ),
      ),
    );

InputDecoration searchBarDec(String hint, Function() onTap) => InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.only(left: 20),
      suffixIcon: IconButton(
        onPressed: onTap,
        icon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.search),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(
          color: Colors.grey, // Change border color as needed
          width: 2.0, // Adjust border width for desired thickness
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(
          color: Colors.blue, // Change focus border color
          width: 2.0, // Adjust border width for desired thickness
        ),
      ),
    );

enum MessageCategory {
  PUBLIC,
  PRIVATE,
  JOIN,
}

void showWarningToast(String warning) {
  Fluttertoast.showToast(
    msg: warning,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.orangeAccent,
    textColor: Colors.white,
    fontSize: 17.0,
  );
}
void showSuccessToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.greenAccent,
    textColor: Colors.white,
    fontSize: 17.0,
  );
}
