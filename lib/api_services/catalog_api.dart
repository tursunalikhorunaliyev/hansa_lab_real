import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/catalog_model.dart';
import 'package:http/http.dart' as http;

enum CatalogAction { get }

class CatalogBloc {
  final dataController = StreamController<CatalogModel>.broadcast();
  StreamSink<CatalogModel> get dataSink => dataController.sink;
  Stream<CatalogModel> get dataStream => dataController.stream;
  final eventController = StreamController<CatalogAction>.broadcast();
  StreamSink<CatalogAction> get eventSink => eventController.sink;
  Stream<CatalogAction> get eventStream => eventController.stream;
  CatalogBloc(token) {
    eventStream.listen((event) async {
      if (event == CatalogAction.get) {
        dataSink.add(await getCatalog(token));
      }
    });
  }

  Future<CatalogModel> getCatalog(token) async {
    http.Response response = await http.get(
        Uri.parse("https://hansa-lab.ru/api/site/catalog"),
        headers: {"token": token});
    return CatalogModel.fromMap(jsonDecode(response.body));
  }
}
