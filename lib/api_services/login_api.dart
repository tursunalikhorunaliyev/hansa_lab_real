import 'dart:convert';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class LoginAction {
  String gate = "https://hansa-lab.ru/api/auth/login";
  final String username;
  final String password;
  final bool isSaved;

  LoginAction(
      {required this.username, required this.password, required this.isSaved});

  Future<List> sendRequest() async {
    http.Response response = await http.post(Uri.parse(gate),
        body: {"username": username, "password": password});
    Map<String, dynamic> responseMap =
        jsonDecode(response.body) as Map<String, dynamic>;
    bool hasToken = false;
    if (responseMap["status"].toString().endsWith("true")) {
      hasToken = true;
      final box = Hive.box("savedUser");
      final keyBox = Hive.box('keyChain');
      if (isSaved) {
        box.put("username", username);
        box.put("password", password);
        box.put("isSaved", true);
        // userList.add(username);
        keyBox.put("email", username);
        keyBox.put("password", password);
      } else {
        box.put("username", username);
        box.put("password", password);
        box.put("isSaved", false);
      }

      return [username, password, hasToken, responseMap["data"]["token"]];
    } else {
      return ["", "", false];
    }
  }
}
