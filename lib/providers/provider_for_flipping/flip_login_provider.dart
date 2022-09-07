import 'package:flutter/material.dart';

class FlipLoginProvider extends ChangeNotifier{
  bool isClosed = false;

  void changeIsClosed(bool isClosed){
    this.isClosed  = isClosed;
    notifyListeners();
  }

  bool get getIsClosed => isClosed;
}