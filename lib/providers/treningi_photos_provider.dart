import 'package:flutter/material.dart';

class TreningiPhotosProvider extends ChangeNotifier {
  String url = '';
  String get getUrl => url;
  setUrl(String newValue) {
    url = newValue;
    notifyListeners();
  }
}
