import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/country_model.dart';
import 'package:hansa_lab/blocs/hansa_country_api.dart';
import 'package:http/http.dart' as http;

class BlocSendId {
  final streamControllerCity = StreamController<CountryModel>.broadcast();
  final eventController = StreamController<CityEnum>.broadcast();

  Stream<CountryModel> get stream => streamControllerCity.stream;
  StreamSink<CountryModel> get sink => streamControllerCity.sink;

  Stream<CityEnum> get eventStrem => eventController.stream;
  StreamSink<CityEnum> get eventSink => eventController.sink;

  final streamControllerId = StreamController<int>.broadcast();
  StreamSink<int> get dataSinkId => streamControllerId.sink;
  Stream<int> get dataStreamId => streamControllerId.stream;

  BlocSendId() {
    eventStrem.listen((event) {
      if (event == CityEnum.city) {
        streamControllerId.stream.listen((event) {
          getData(event).then((value) {
            sink.add(value);
          });
        });
      }
    });
  }

  Future<CountryModel> getData(int id) async {
    http.Response response = await http.get(
      Uri.parse("http://hansa-lab.ru/api/dictionary/city?id=$id"),
    );

    return CountryModel.fromMap(jsonDecode(response.body));
  }
}
