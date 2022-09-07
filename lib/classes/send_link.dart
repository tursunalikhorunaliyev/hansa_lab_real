import 'package:flutter/material.dart';

class SendLink extends ChangeNotifier {
   String link = "";

  setLink(String url) {
    link = url;
    notifyListeners();
  }

  String get getLInk => link;
}
