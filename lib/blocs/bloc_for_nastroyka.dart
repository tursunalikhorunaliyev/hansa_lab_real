import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hansa_lab/api_models.dart/nastroyka_model.dart';
import 'package:http/http.dart' as http;

enum Nastroyka { nastroyka }

class BlocForNastroyka {
  final dataController = StreamController<NastroykaModel>.broadcast();
  final eventController = StreamController<Nastroyka>.broadcast();

  StreamSink<NastroykaModel> get dataSink => dataController.sink;
  Stream<NastroykaModel> get dataStream => dataController.stream;

  StreamSink<Nastroyka> get eventSink => eventController.sink;
  Stream<Nastroyka> get eventStream => eventController.stream;
  BlocForNastroyka(token) {
    eventStream.listen((event) async {
      if (event == Nastroyka.nastroyka) {
        dataSink.add(await getData(token));
      }
    });
  }

  Future<NastroykaModel> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("https://hansa-lab.ru/api/site/unsubscribe"),
      headers: {"token": token},
    );

    return NastroykaModel.fromMap(jsonDecode(response.body));
  }

  Future postData(token) async {
    http.Response response = await http.post(
      Uri.parse("https://hansa-lab.ru/api/site/unsubscribe"),
      headers: {"token": token},
    );
    log("${response.body} bloc nastroyka");
    log("${response.statusCode} bloc nastroyka");
  }
}
