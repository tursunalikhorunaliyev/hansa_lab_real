import 'dart:convert';
import 'dart:developer';

import 'package:hansa_lab/api_models.dart/read_stati_model.dart';
import 'package:http/http.dart' as http;

class ReadStatieServices {
  static Future<ReadStatiModel> getData(token, url) async {
    var headers = {'token': token.toString()};
    http.Response response =
        await http.get(Uri.parse("http://hansa-lab.ru/$url"), headers: headers);
    log("${response.statusCode}keldi");
    return ReadStatiModel.fromMap(jsonDecode(response.body));
  }
}
