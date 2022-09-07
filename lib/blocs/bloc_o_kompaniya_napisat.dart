import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/model_o_kompaniya_napisat.dart';
import 'package:hansa_lab/enums/enum_action_view.dart';
import 'package:http/http.dart' as http;

class BlocOKompaniyaNapisat {
  final dataController =
      StreamController<ModelOKompaniyaNapisatMain>.broadcast();
  final eventController = StreamController<EnumActionView>.broadcast();

  StreamSink<ModelOKompaniyaNapisatMain> get dataSink => dataController.sink;
  Stream<ModelOKompaniyaNapisatMain> get dataStream => dataController.stream;

  StreamSink<EnumActionView> get eventSink => eventController.sink;
  Stream<EnumActionView> get eventStream => eventController.stream;

  BlocOKompaniyaNapisat(token) {
    eventStream.listen((event) async {
      if (event == EnumActionView.view) {
        dataSink.add(await getData(token));
      }
    });
  }
  late Map body;

  Future setText(text) async {
    body = {"text": text};
  }

  Future<ModelOKompaniyaNapisatMain> getData(token) async {
    http.Response response = await http.post(
        Uri.parse("http://hansa-lab.ru/api/site/add-problem"),
        headers: {"token": token},
        body: body);

    return ModelOKompaniyaNapisatMain.fromMap(jsonDecode(response.body));
  }
}
