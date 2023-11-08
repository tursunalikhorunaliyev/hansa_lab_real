import 'package:flutter/material.dart';

class ArticleTitleProvider extends ChangeNotifier {
  String title = "";
  String get getTitle => title;
  changeTitle(String title) {
    this.title = title;
    notifyListeners();
  }
}
