import 'package:flutter/cupertino.dart';

class ProviderOtpravitPushUvodamleniya extends ChangeNotifier {
  Alignment alignment = Alignment.centerLeft;

  setAlignment(Alignment alignment) {
    this.alignment = alignment;
    notifyListeners();
  }

  Alignment get getAlignment => alignment;
}
