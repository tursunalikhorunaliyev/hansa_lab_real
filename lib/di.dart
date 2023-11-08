import 'package:flutter/material.dart';
import 'package:hansa_lab/screens/splash_screen.dart';
import 'api_services/my_firebase.dart';

Future<void> setup({Widget? firstPage}) async {
  await _registerUtils();

  await _registerHome();
}

Future<void> _registerUtils() async {
  await MyFirebase.ensureInitialized();
}

Future<void> _registerHome() async {
  home = await MyFirebase.checkUpdate(home) ?? home;
}

// Widget home = const MainPage();
Widget home = SplashScreen();
// Widget home = SmsVerify();
