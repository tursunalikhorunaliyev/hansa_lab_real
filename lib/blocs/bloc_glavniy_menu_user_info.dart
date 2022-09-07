import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/model_glavniy_menu_user_info.dart';
import 'package:hansa_lab/enums/enum_action_view.dart';
import 'package:http/http.dart' as http;

class BlocGlavniyMenuUserInfo {
  final dataController =
      StreamController<ModelGlavniyMenuUserInfoMain>.broadcast();
  final eventController = StreamController<EnumActionView>.broadcast();

  StreamSink<ModelGlavniyMenuUserInfoMain> get dataSink => dataController.sink;
  Stream<ModelGlavniyMenuUserInfoMain> get dataStream => dataController.stream;

  StreamSink<EnumActionView> get eventSink => eventController.sink;
  Stream<EnumActionView> get eventStream => eventController.stream;

  BlocGlavniyMenuUserInfo(token) {
    eventStream.listen((event) async {
      if (event == EnumActionView.view) {
        dataSink.add(await getData(token));
      }
    });
  }

  Future<ModelGlavniyMenuUserInfoMain> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("https://hansa-lab.ru/api/site/user-short-info"),
      headers: {"token": token},
    );

    return ModelGlavniyMenuUserInfoMain.fromMap(jsonDecode(response.body));
  }
}
