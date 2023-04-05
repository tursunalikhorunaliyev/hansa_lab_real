import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ReadStatiSendCommentService {
  static Future<Map<String, dynamic>> getData(
      String token, String url, Map<String, dynamic> body) async {
    var headers = {'token': token.toString()};
    http.Response response = await http.post(
        Uri.parse("https://hansa-lab.ru/$url"),
        headers: headers,
        body: body);
    return jsonDecode(response.body);
  }
}
