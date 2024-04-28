import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spordee_messaging_app/root_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  runApp(const RootHome());
}