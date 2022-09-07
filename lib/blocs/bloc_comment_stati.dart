import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:hansa_lab/api_models.dart/stati_comment_model.dart';

enum StatiComentEnum { coment }

class BlocForStatiComment {
  Future<StatiComentModel> getComment(url, token) async {
    Map<String, String> headers = {'token': token};
    http.Response response =
        await http.get(Uri.parse('http://hansa-lab.ru/$url'), headers: headers);
    log("${jsonDecode(response.body)['data']}    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    return StatiComentModel.fromMap(jsonDecode(response.body));
  }
}
