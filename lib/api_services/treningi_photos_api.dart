import 'dart:convert';
import 'dart:developer';

import 'package:hansa_lab/api_models.dart/treningi_photos_model.dart';
import 'package:http/http.dart' as http;

class TreningiPhotosApi {
  static Future<TreningiPhotosModel> getdata(url, token) async {
    http.Response response = await http
        .get(Uri.parse('http://hansa-lab.ru/$url'), headers: {'token': token});
    log(jsonDecode(response.body).toString());
    return TreningiPhotosModel.fromMap(jsonDecode(response.body));
  }
}
