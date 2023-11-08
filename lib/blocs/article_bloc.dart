import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hansa_lab/api_models.dart/article_model.dart';
import 'package:http/http.dart' as http;

class ArticleBLoC {
  final controller = StreamController<ArticleModel>.broadcast();

  Stream<ArticleModel> get stream => controller.stream;
  StreamSink<ArticleModel> get sink => controller.sink;

  Future<ArticleModel> getArticle(token, url) async {
    if (kDebugMode) {
      print(token);
    }
    if (kDebugMode) {
      print(url);
    }
    var headers = {'token': token.toString()};
    print(headers);
    var request = http.Request('GET', Uri.parse("https://hansa-lab.ru/$url"));
    print(request);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    Map<String, dynamic>? map;
    if (response.statusCode == 200) {
      await response.stream
          .bytesToString()
          .then((value) => map = jsonDecode(value) as Map<String, dynamic>);
    }

    return ArticleModel.fromMap(map!);
  }
}
