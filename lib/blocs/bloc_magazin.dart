import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/model_magazin.dart';
import 'package:hansa_lab/enums/enum_action_view.dart';
import 'package:http/http.dart' as http;

class BlocMagazin {
  final dataController = StreamController<ModelMagazinMain>.broadcast();
  final eventController = StreamController<EnumActionView>.broadcast();

  StreamSink<ModelMagazinMain> get dataSink => dataController.sink;
  Stream<ModelMagazinMain> get dataStream => dataController.stream;

  StreamSink<EnumActionView> get eventSink => eventController.sink;
  Stream<EnumActionView> get eventStream => eventController.stream;

  BlocMagazin(token) {
    eventStream.listen((event) async {
      if (event == EnumActionView.view) {
        dataSink.add(await getData(token));
      }
    });
  }

  Future<ModelMagazinMain> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("https://hansa-lab.ru/api/dictionary/store"),
      headers: {"token": token},
    );

    return ModelMagazinMain.fromMap(jsonDecode(response.body));
  }
}
