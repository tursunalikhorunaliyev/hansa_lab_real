import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hansa_lab/blocs/fcm_article_bloc.dart';
import 'package:hansa_lab/firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications',
  importance: Importance.max,
  playSound: true,
);

initMessaging(FcmArticleBloC fcmArticleBloc) async {
  log("FirebaseMessaging initializing...");
  var androidInit =
      const AndroidInitializationSettings("@mipmap/launcher_icon");
  var iosInitializationSettings = const DarwinInitializationSettings();
  var initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInitializationSettings,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveNotificationResponse,
  );

  FirebaseMessaging.onMessageOpenedApp.listen(fcmArticleBloc.getNewsIdFromFCM);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  FlutterAppBadger.updateBadgeCount(1);
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
  }
  // await Navigator.push(
  //   context,
  //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  // );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterAppBadger.updateBadgeCount(1);
  log("FirebaseMessaging working on background...");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

onBackground() {
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
  });
}

listenForeground(FcmArticleBloC fcmArticleBloc) {
  // FlutterAppBadger.updateBadgeCount(1);
  // FlutterAppBadger.removeBadge();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log("FirebaseMessaging listened...");
    log(message.notification!.title ?? "Notification not received...");
    fcmArticleBloc.getNewsIdFromFCM(message);
    RemoteNotification notification = message.notification!;
    AndroidNotification? androidNotification = message.notification!.android;
    AppleNotification? appleNotification = message.notification!.apple;
    var androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      icon: androidNotification?.smallIcon,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDetails = const DarwinNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    if (message.notification != null &&
        androidNotification != null &&
        appleNotification != null) {
      flutterLocalNotificationsPlugin.show(notification.hashCode,
          notification.title, notification.body, notificationDetails);
    }
  });
}

requestMessaging() async {
  log("FirebaseMessaging requesting...");
  FirebaseMessaging messaging = FirebaseMessaging.instance;
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
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
}
