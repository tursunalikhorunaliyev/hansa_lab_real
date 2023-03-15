import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

class NotificationToken {
  String type = '';

  Future<String> getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (Platform.isIOS) {
      type = "ios";
    } else if (Platform.isAndroid) {
      type = "android";
    }
    Map<String, String> body = {"token": fcmToken.toString(), "type": type};
    await post(
      Uri.parse("https://hansa-lab.ru/api/auth/register-token"),
      body: body,
    );
    return fcmToken!;
  }
}
