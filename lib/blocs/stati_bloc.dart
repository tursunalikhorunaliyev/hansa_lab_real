import 'dart:async';
import 'dart:convert';
import 'package:hansa_lab/api_models.dart/stati_model.dart';
import 'package:http/http.dart' as http;

class StatiBLoC {
  Future<StatiModel> getStati(token) async {
    var headers = {'token': token.toString()};
    var request = http.Request(
        'GET', Uri.parse('https://hansa-lab.ru/api/site/usefull-articles'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    Map<String, dynamic>? map;

    if (response.statusCode == 200) {
      await response.stream.bytesToString().then((value) {
        map = jsonDecode(value) as Map<String, dynamic>;
      });
    } else {}
    return StatiModel.fromJson(map!);
  }
}
