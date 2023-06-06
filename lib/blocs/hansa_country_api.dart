import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hansa_lab/api_models.dart/country_model.dart';
import 'package:http/http.dart' as http;

enum CityEnum { city }

class HansaCountryBloC {
  final streamController = StreamController<CountryModel>.broadcast();
  final eventController = StreamController<CityEnum>.broadcast();

  Stream<CountryModel> get stream => streamController.stream;

  StreamSink<CountryModel> get sink => streamController.sink;

  Stream<CityEnum> get eventStrem => eventController.stream;

  StreamSink<CityEnum> get eventSink => eventController.sink;

  HansaCountryBloC(int? id) {
    eventStrem.listen((event) async {
      int i = 0;
      if (i == 0) {
        if (id == null) {
          await getCityData();
        } else {
          await getData(id);
        }
        ++i;
      }
      if (event == CityEnum.city) {
        if (id == null) {
          sink.add(await getCityData());
        } else {
          sink.add(await getData(id));
        }
      }
    });
  }

  Future<CountryModel> getData(id) async {
    final String url = "http://hansa-lab.ru/api/dictionary/city?id=$id";
    http.Response response = await http.get(
      Uri.parse(url),
    );
    return CountryModel.fromMap(jsonDecode(response.body));
  }

  Future<CountryModel> getCityData() async {
    const String url = "https://hansa-lab.ru/api/dictionary/country-type";
    http.Response response = await http.get(
      Uri.parse(url),
    );
    return CountryModel.fromMap(jsonDecode(response.body));
  }
}
