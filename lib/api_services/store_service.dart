import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/store_model.dart';
import 'package:hansa_lab/api_services/api_urls.dart';
import 'package:http/http.dart';

enum StoreEnum { store }

class StoreData {
  final streamController = StreamController<StoreModel>.broadcast();
  final eventController = StreamController<StoreEnum>.broadcast();

  Stream<StoreModel> get stream => streamController.stream;
  StreamSink<StoreModel> get sink => streamController.sink;

  Stream<StoreEnum> get eventStrem => eventController.stream;
  StreamSink<StoreEnum> get eventSink => eventController.sink;

  StoreData() {
    eventStrem.listen((event) async {
      if (event == StoreEnum.store) {
        sink.add(await getStores());
      }
    });
  }

  Future<StoreModel> getStores() async {
    Response response = await get(Uri.parse(APIUrls().getStoreUrl));
    return StoreModel.fromMap(jsonDecode(response.body));
  }
}
