import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/model_gorod.dart';
import 'package:hansa_lab/enums/enum_action_view.dart';
import 'package:http/http.dart' as http;

class BlocGorod {
  final dataController = StreamController<ModelGorodMain>();
  final eventController = StreamController<EnumActionView>();

  StreamSink<ModelGorodMain> get dataSink => dataController.sink;
  Stream<ModelGorodMain> get dataStream => dataController.stream;

  StreamSink<EnumActionView> get eventSink => eventController.sink;
  Stream<EnumActionView> get eventStream => eventController.stream;

  BlocGorod(token) {
    eventStream.listen((event) async {
      if (event == EnumActionView.view) {
        dataSink.add(await getData(token));
      }
    });
  }

  Future<ModelGorodMain> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("https://hansa-lab.ru/api/dictionary/city?id=1"),
      headers: {"token": token},
    );

    return ModelGorodMain.fromMap(jsonDecode(response.body));
  }
}
