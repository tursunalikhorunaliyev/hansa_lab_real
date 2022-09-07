import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications',
  importance: Importance.max,
  playSound: true,
);

initMessaging() async {
  log("FirebaseMessaging initializing...");
  var androidInit =
      const AndroidInitializationSettings("@mipmap/launcher_icon");
  var iosInit = const IOSInitializationSettings();
  var initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("FirebaseMessaging working on background...");
  await Firebase.initializeApp();
}

listenForeground(AndroidNotificationChannel channel) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log("FirebaseMessaging listened...");
    log(message.notification!.title ?? "Notification not received...");
    RemoteNotification notification = message.notification!;
    AndroidNotification? androidNotification = message.notification!.android;
    var androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      icon: androidNotification?.smallIcon,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDetails = const IOSNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    if (message.notification != null && androidNotification != null) {
      flutterLocalNotificationsPlugin.show(notification.hashCode,
          notification.title, notification.body, notificationDetails);
    }
  });
}

requestMessaging() async {
  log("FirebaseMessaging requesting...");
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestPermission();
}
