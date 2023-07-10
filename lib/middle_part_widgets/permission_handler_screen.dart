import 'dart:io';

import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hansa_lab/api_services/my_firebase.dart';
import 'package:hansa_lab/firebase_dynamiclinks.dart';
import 'package:hansa_lab/screens/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerScreen extends StatefulWidget {
  int? androidVersion;

  PermissionHandlerScreen({Key? key, this.androidVersion}) : super(key: key);

  @override
  State<PermissionHandlerScreen> createState() =>
      _PermissionHandlerScreenState();
}

class _PermissionHandlerScreenState extends State<PermissionHandlerScreen> {
  bool? isPlatform;

  @override
  void initState() {
    getPermission().then((value) {
      if (value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      } else {
        exit(0);
      }
    });
    super.initState();
  }

  Future<bool> getPermission() async {
    var permissioAndroid = await Permission.storage.request();
    var permissionIos = await Permission.notification.request();
    if (Platform.isIOS) {
      isPlatform = !permissionIos.isGranted;
    } else if (Platform.isAndroid) {
      if (widget.androidVersion! >= 33) {
        isPlatform = !permissioAndroid.isGranted;
      } else if (widget.androidVersion! < 33) {
        isPlatform = permissioAndroid.isGranted;
      }
    }
    if (isPlatform!) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
