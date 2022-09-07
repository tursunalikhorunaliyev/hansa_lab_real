import 'package:flutter/cupertino.dart';

class TreningiVideoChangerProvider extends ChangeNotifier {
  String url = "";
  String get getUrl => url;
  setUrl(String url) {
    this.url = url;
    notifyListeners();
  }
}
