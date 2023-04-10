import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Listens FCM notifications. If there is [articleId] in the data.
// It captures  [articleId] and notifies its listeners
class FcmArticleBloC extends ChangeNotifier {
  String? _articleId;

  String get articleLink => 'api/site/article?id=$_articleId';
  bool get hasArticleId => _articleId != null;
  bool get empty => _articleId == null;

  // notifies if articleId is not null
  set articleId(String? articleId) {
    _articleId = articleId;
    if (_articleId != null) {
      notifyListeners();
    }
  }

  String? get articleId {
    return _articleId;
  }

  void getNewsIdFromFCM(RemoteMessage? message) {
    if (message == null) return;
    final data = message.data;
    if (data.containsKey('news_id')) {
      _articleId = data['news_id'];
      notifyListeners();
    }
  }
}
