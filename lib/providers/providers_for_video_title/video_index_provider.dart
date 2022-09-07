import 'package:flutter/material.dart';

class VideoIndexProvider extends ChangeNotifier {
  int index = 0;
  int get getIndex => index;
  changeIndex(int index) {
    this.index = index;
    notifyListeners();
  }
}
