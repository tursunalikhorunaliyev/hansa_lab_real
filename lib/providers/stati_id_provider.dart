import 'package:flutter/cupertino.dart';

class StatiIdProvider extends ChangeNotifier {
  String url = "";
  String get getUrl => url;
  changeUrl(String url) {
    this.url = url;
    notifyListeners();
  }
}
