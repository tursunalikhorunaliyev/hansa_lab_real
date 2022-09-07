import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/model_personal.dart';
import 'package:http/http.dart' as http;

class BlocPersonal {
  Future<ModelPersonalMain> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("https://hansa-lab.ru/api/site/account"),
      headers: {"token": token},
    );

    return ModelPersonalMain.fromMap(jsonDecode(response.body));
  }
}
