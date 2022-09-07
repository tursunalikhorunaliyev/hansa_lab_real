import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/read_stati_model.dart';
import 'package:http/http.dart' as http;

class ReadStatiBLoC {
  final controller = StreamController<ReadStatiModel>.broadcast();

  Stream<ReadStatiModel> get stream => controller.stream;
  StreamSink<ReadStatiModel> get sink => controller.sink;

  Future<ReadStatiModel> getReadStati(token, url) async {
    var headers = {'token': token.toString()};
    var request = http.Request('GET', Uri.parse("https://hansa-lab.ru/$url"));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    Map<String, dynamic>? map;
    if (response.statusCode == 200) {
      await response.stream
          .bytesToString()
          .then((value) => map = jsonDecode(value) as Map<String, dynamic>);
    }
    return ReadStatiModel.fromMap(map!);
  }
}
