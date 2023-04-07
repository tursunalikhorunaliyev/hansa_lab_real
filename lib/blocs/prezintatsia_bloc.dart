import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/prezintatsi_model.dart';
import 'package:http/http.dart' as http;

enum PrezintatsiaAction { show }

class PrezintatsiaBLoC {
  final controller = StreamController<PrezintatsiaModel>();
  final controllerAction = StreamController<PrezintatsiaAction>();

  StreamSink<PrezintatsiaAction> get sinkAction => controllerAction.sink;
  Stream<PrezintatsiaAction> get streamAction => controllerAction.stream;
  StreamSink<PrezintatsiaModel> get sink => controller.sink;
  Stream<PrezintatsiaModel> get stream => controller.stream;

  PrezintatsiaBLoC(token, String url) {
    streamAction.listen((event) async {
      if (event == PrezintatsiaAction.show) {
        sink.add(await getPrezintatsiyaData(token, url));
      }
    });
  }

  Future<PrezintatsiaModel> getPrezintatsiyaData(token, String url) async {
    http.Response response = await http.post(
      Uri.parse("https://hansa-lab.ru/$url"),
      headers: {"token": token},
    );
    print(jsonDecode(response.body));
    return PrezintatsiaModel.fromMap(jsonDecode(response.body));
  }
}
