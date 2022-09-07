import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:hansa_lab/api_models.dart/treningi_video_model.dart';

class TreningiVideoApi {
  static Future<TreningiVideoModel> getTreningiVideo(url, token) async {
    http.Response response = await http.get(
        Uri.parse("https://hansa-lab.ru/$url"),
        headers: {"token": token});
    return TreningiVideoModel.fromMap(jsonDecode(response.body));
  }
}
