import 'dart:async';
import 'dart:convert';
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

  HansaCountryBloC(id) {
    eventStrem.listen((event) async {
      int i = 0;
      if (i == 0) {
        await getData(id);
        ++i;
      }
      if (event == CityEnum.city) {
        sink.add(await getData(id));
      }
    });
  }

  Future<CountryModel> getData(id) async {
    http.Response response = await http.get(
      Uri.parse("http://hansa-lab.ru/api/dictionary/city?id=$id"),
    );

    return CountryModel.fromMap(jsonDecode(response.body));
  }
}
