import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/video/model_video.dart';
import 'package:http/http.dart';

import 'article_video_model.dart';

enum ActionVideo {
  view,
}

class ArticleVideoApi {
  Future<ArticleVideoModel> getData(
      {required String token, required String videoName}) async {
    Response response = await post(
        Uri.parse("https://hansa-lab.ru/api/site/video-name"),
        headers: {"token": token},
        body: {"video": videoName});
    return ArticleVideoModel.fromJson(jsonDecode(response.body));
  }
}
