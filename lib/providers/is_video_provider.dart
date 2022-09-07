import 'package:flutter/cupertino.dart';

class IsVideoprovider extends ChangeNotifier {
  bool isVideo = false;
  bool get getIsVideo => isVideo;
  setIsVideo(bool newValue) {
    isVideo = newValue;
    notifyListeners();
  }
}
