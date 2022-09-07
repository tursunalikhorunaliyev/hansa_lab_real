import 'package:flutter/material.dart';

class EventTitleProvider extends ChangeNotifier {
  List<String> get getTitles => titles;
  List<String> titles = [];
  changeTitles(newTitle, index) {
    titles.removeAt(index);
    titles.insert(index, newTitle);
    notifyListeners();
  }

  addTitles(newTitle) {
    titles.add(newTitle);
    notifyListeners();
  }
}
