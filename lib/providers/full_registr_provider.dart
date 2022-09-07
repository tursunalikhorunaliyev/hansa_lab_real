import 'package:flutter/material.dart';

class FullRegisterDataProvider extends ChangeNotifier{
  String dataRojdeniya = "";
  String? nazvaniyaSeti;
  String? doljnost;
  String gorod ="";

  addData({required String dataRojdeniya, String? nazvaniyaSeti, String? doljnost, required String gorod}){
   
    this.dataRojdeniya = dataRojdeniya;
    this.nazvaniyaSeti = nazvaniyaSeti;
    this.doljnost = doljnost;
    this.gorod = gorod;
   
    notifyListeners();
  }
}