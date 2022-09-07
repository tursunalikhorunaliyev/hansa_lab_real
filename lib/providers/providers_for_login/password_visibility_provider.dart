import 'package:flutter/material.dart';

class PasswordVisibilityProvider extends ChangeNotifier{
  bool isVisible = false;

  void changeVisibility(){
    isVisible = !isVisible;
    notifyListeners();
  }
  bool get getVisibility => isVisible;
}