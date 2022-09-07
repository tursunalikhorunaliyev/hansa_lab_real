import 'dart:async';

import 'package:hansa_lab/api_models.dart/country_model.dart';

class BlocLocalCities {
  final controller = StreamController<CountryModel>.broadcast();
  StreamSink<CountryModel> get sink => controller.sink;
  Stream<CountryModel> get stream => controller.stream;
}
