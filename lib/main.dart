import 'package:flutter/material.dart';
import 'package:exchange_app/di/dependency_injection.dart';
import 'package:exchange_app/app.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Injector.configure(Flavor.MOCK);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool themeLightMode = prefs.getBool("themeLightMode") ?? false;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black));

  // TODO: implement themeLightMode
  runApp(MyApp());
}
