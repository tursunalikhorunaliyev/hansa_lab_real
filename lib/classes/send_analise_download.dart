import 'package:flutter/cupertino.dart';

class SendAnaliseDownload extends ChangeNotifier {
  bool analise = true;
  setAnalise(bool analiseP) {
    analise = analiseP;
    notifyListeners();
  }

  bool get getAnalise => analise;
}
