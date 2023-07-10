import 'package:flutter/material.dart';
import 'package:hansa_lab/middle_part_widgets/permission_handler_screen.dart';
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
Widget home = PermissionHandlerScreen();
// Widget home = SmsVerify();
