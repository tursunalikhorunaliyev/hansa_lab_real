import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/video/model_video.dart';
import 'package:http/http.dart';

enum ActionVideo {
  view,
}

class BlocVideoApi {
  Future<VideoMainOne> getData({
    required String token,
  }) async {
    Response response = await get(
      Uri.parse("https://hansa-lab.ru/api/site/video"),
      headers: {"token": token},
    );
    return VideoMainOne.fromMap(jsonDecode(response.body));
  }
}
