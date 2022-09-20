import 'package:flutter/cupertino.dart';

class CheckClick extends ChangeNotifier {
  int i = 0;
  incree() {
    i++;
    notifyListeners();
  }
}
