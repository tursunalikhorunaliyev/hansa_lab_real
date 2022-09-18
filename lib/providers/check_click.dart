import 'package:flutter/cupertino.dart';

class CheckClick extends ChangeNotifier {
  int i = 0;
  int get getI => i;
  incree() {
    i++;
    notifyListeners();
  }
}
