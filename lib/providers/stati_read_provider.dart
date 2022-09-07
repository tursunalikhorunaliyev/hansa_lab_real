import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hansa_lab/api_models.dart/stati_comment_model.dart';

class ReadStatiProvider extends ChangeNotifier {
  List<Map<String, dynamic>> comments = [];

  Future<StatiComentModel> getComment(id, token) async {
    Map<String, String> headers = {'token': token};
    http.Response response = await http.get(
        Uri.parse('http://hansa-lab.ru/api/site/messages?id=$id'),
        headers: headers);
    return StatiComentModel.fromMap(jsonDecode(response.body));
  }
}
