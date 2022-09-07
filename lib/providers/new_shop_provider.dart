
import 'package:flutter/material.dart';

class NewShopProvider extends ChangeNotifier {
  String newShop = "";
  String get getNewShop => newShop;
  setNewShop(String newShop) {
    this.newShop = newShop;
    notifyListeners();
  }
}
