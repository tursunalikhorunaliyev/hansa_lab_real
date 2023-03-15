import 'package:flutter/material.dart';

class PasswordVisibilityProvider extends ChangeNotifier{
  bool isVisible = true;

  void changeVisibility(){
    isVisible = !isVisible;
    notifyListeners();
  }
  bool get getVisibility => isVisible;
}