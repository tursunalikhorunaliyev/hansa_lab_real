import 'dart:io';

import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hansa_lab/middle_part_widgets/permission_handler_screen.dart';

import '../screens/update_page.dart';
import 'my_remote.dart';

dynamic platformVersion;

class MyFirebase {

  static Future<void> ensureInitialized() async {

    if (Platform.isAndroid) {
      try {
        platformVersion = await DeviceInformation.apiLevel;
      } on PlatformException {
        platformVersion = 'Failed to get platform version.';
      }
    }
    await MyRemote.ensureInitialized();
  }

  static Future<Widget?> checkUpdate(Widget home) async {
    final updateType = await MyRemote.getUpdateType();
    if (updateType == UpdateType.none) {
      return PermissionHandlerScreen(
        androidVersion: platformVersion,
      );
    }
    return UpdatePage(home, skip: updateType == UpdateType.small);
  }
}
