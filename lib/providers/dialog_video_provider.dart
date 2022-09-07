import 'package:flutter/cupertino.dart';

class DialogVideoProvider extends ChangeNotifier {
  int selectedIndex = 0;
  String selectedTitle = "";
  int get getSelectedIndex => selectedIndex;
  String get getSelectedTitle => selectedTitle;
  changeSelectedIndex(int newIndex) {
    selectedIndex = newIndex;
    notifyListeners();
  }

  changeSelectedTitle(String newTitle) {
    selectedTitle = newTitle;
    notifyListeners();
  }
}
