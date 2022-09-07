
import 'package:flutter/material.dart';
import 'package:hansa_lab/blocs/login_clicked_bloc.dart';

class LoginClickedProvider extends ChangeNotifier{
  LoginAction loginAction = LoginAction.signin;
  void changeLoginAction(LoginAction action){
    loginAction = action;
    notifyListeners();
  }
  LoginAction get getAction => loginAction;
}