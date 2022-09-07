import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ReadStatiSendCommentService {
  static Future<Map<String, dynamic>> getData(
      String token, String url, Map<String, dynamic> body) async {
    var headers = {'token': token.toString()};
    http.Response response = await http.post(
        Uri.parse("http://hansa-lab.ru/$url"),
        headers: headers,
        body: body);
    log(response.statusCode.toString());
    log("${response.body} BODYYYYYYYYYYY");
    return jsonDecode(response.body);
  }
}
