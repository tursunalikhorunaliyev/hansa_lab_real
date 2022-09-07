import 'dart:developer';

import 'package:flutter/cupertino.dart';

class TreningiVideosProvider extends ChangeNotifier {
  String url = '';
  String get getUrl => url;
  setUrl(String newValue) {
    url = newValue;
    log("newUrl is $getUrl");
    notifyListeners();
  }
}
