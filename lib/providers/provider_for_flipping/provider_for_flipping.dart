import 'package:flutter/material.dart';

class FlipProvider extends ChangeNotifier{
  bool isFlip = false;

  void changeFlipping(){
    isFlip = !isFlip;
    notifyListeners();
  }
  bool get getIsFlip => isFlip;
}