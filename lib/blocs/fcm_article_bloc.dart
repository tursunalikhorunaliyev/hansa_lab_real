import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Listens FCM notifications. If there is [articleId] in the data.
// It captures  [articleId] and notifies its listeners
class FcmArticleBloC extends ChangeNotifier {
  FcmArticleBloC._();
  static final FcmArticleBloC _instance = FcmArticleBloC._();
  factory FcmArticleBloC() => _instance;

  final Set<int> articleIds = {};
  final Map<String, String> logs = {};

  void getNewsIdFromMsg(RemoteMessage? message) {
    if (message == null) return;
    final data = message.data;
    if (data.containsKey('news_id')) {
      final id = int.tryParse(data['news_id']);
      if (id == null) return;
      if (articleIds.contains(id)) return;
      articleIds.add(id);
      notifyListeners();
    }
  }

  void log(String key, String val) {
    logs[key] = val;
  }
}
