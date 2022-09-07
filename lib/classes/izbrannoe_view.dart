import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class IzbrannoeView extends ChangeNotifier {
   bool isFavourite = false;
  setFavourite(fav) {
    
    isFavourite = fav;
    notifyListeners();
      
  }
  bool getIsFavourite() => isFavourite;
}
