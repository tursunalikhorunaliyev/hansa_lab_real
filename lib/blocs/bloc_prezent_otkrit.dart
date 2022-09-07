import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/model_prezent_otkrit.dart';
import 'package:http/http.dart' as http;

class BlocPrezentOtkrit {
  Future<ModelPrezentOtkritMain> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("https://hansa-lab.ru/api/site/category-presentation"),
      headers: {"token": token},
    );

    return ModelPrezentOtkritMain.fromMap(jsonDecode(response.body));
  }
}
