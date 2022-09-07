import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class FavouriteBLoC {
  final controller = StreamController<bool>();
  Stream<bool> get stream => controller.stream;
  StreamSink<bool> get sink => controller.sink;

  Future<bool> getFavourite(token, url) async {
    var headers = {'token': token.toString()};
    var request = http.Request('POST', Uri.parse("https://hansa-lab.ru/$url"));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    Map<String, dynamic>? map;
    if (response.statusCode == 200) {
      await response.stream
          .bytesToString()
          .then((value) => map = jsonDecode(value) as Map<String, dynamic>);
    }

    return map!['status'];
  }
}
