import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hansa_lab/enums/enum_push_uvodamleniya.dart';
import 'package:http/http.dart' as http;

class BlocPushUvodamleniya {
  final dataController = StreamController<bool>.broadcast();
  final eventController = StreamController<EnumPushUvodamleniya>.broadcast();

  StreamSink<bool> get dataSink => dataController.sink;
  Stream<bool> get dataStream => dataController.stream;

  StreamSink<EnumPushUvodamleniya> get eventSink => eventController.sink;
  Stream<EnumPushUvodamleniya> get eventStream => eventController.stream;
  BlocPushUvodamleniya(token) {
    eventStream.listen((event) async {
      if (event == EnumPushUvodamleniya.fetch) {
        dataSink.add(await getData(token));
      }
    });
  }

  Future<bool> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("http://hansa-lab.ru/api/auth/token?token=$token"),
    );
    log("${response.body} bloc push uvodamleniya get");
    log("${response.statusCode} bloc push uvodamleniya get");
    return jsonDecode(response.body)['data'];
  }

  Future postData(token) async {
    http.Response response = await http.post(
        Uri.parse("http://hansa-lab.ru/api/auth/token"),
        body: {"token": token});
    log("${response.body} bloc push uvodamleniya post");
    log("${response.statusCode} bloc push uvodamleniya post");
  }
}
