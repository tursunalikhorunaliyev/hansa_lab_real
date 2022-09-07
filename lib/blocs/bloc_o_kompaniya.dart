import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/model_o_kompaniya.dart';
import 'package:hansa_lab/enums/enum_action_view.dart';
import 'package:http/http.dart' as http;

class BlocOKompaniya {
  final dataController = StreamController<ModelOKompaniyaMain>.broadcast();
  final eventController = StreamController<EnumActionView>.broadcast();

  StreamSink<ModelOKompaniyaMain> get dataSink => dataController.sink;
  Stream<ModelOKompaniyaMain> get dataStream => dataController.stream;

  StreamSink<EnumActionView> get eventSink => eventController.sink;
  Stream<EnumActionView> get eventStream => eventController.stream;

  BlocOKompaniya(token) {
    eventStream.listen((event) async {
      if (event == EnumActionView.view) {
        dataSink.add(await getData(token));
      }
    });
  }

  Future<ModelOKompaniyaMain> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("http://hansa-lab.ru/api/site/greeting"),
      headers: {"token": token},
    );

    return ModelOKompaniyaMain.fromMap(jsonDecode(response.body));
  }
}
