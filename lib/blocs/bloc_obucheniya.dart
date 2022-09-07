import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/obucheniya_model_api.dart';
import 'package:http/http.dart' as http;

enum ObucheniyaEnum { obucheniya }

class BlocObucheniya {
  final streamController = StreamController<ObucheniyaModel>.broadcast();
  final eventController = StreamController<ObucheniyaEnum>.broadcast();

  Stream<ObucheniyaModel> get stream => streamController.stream;
  StreamSink<ObucheniyaModel> get sink => streamController.sink;

  Stream<ObucheniyaEnum> get eventStream => eventController.stream;
  StreamSink<ObucheniyaEnum> get eventSink => eventController.sink;

  BlocObucheniya(token) {
    eventStream.listen((event) async {
      if (event == ObucheniyaEnum.obucheniya) {
        sink.add(await getObucheniya(token));
      }
    });
  }

  Future<ObucheniyaModel> getObucheniya(token) async {
    var headers = {'token': token.toString()};
    var request =
        http.Request('GET', Uri.parse('https://hansa-lab.ru/api/site/study'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    Map<String, dynamic>? map;

    if (response.statusCode == 200) {
      await response.stream.bytesToString().then((value) {
        map = jsonDecode(value) as Map<String, dynamic>;
      });
    } else {}
    return ObucheniyaModel.fromMap(map!);
  }
}
