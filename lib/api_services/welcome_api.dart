import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hansa_lab/api_models.dart/welcome_model.dart';
import 'package:hansa_lab/api_services/api_urls.dart';
import 'package:http/http.dart';

enum WelcomeApiAction { fetch, update }

class WelcomeApi {
  final dataController = StreamController<List<WelcomeModelData>>.broadcast();
  StreamSink<List<WelcomeModelData>> get dataSink => dataController.sink;
  Stream<List<WelcomeModelData>> get dataStream => dataController.stream;
  final eventController = StreamController<WelcomeApiAction>.broadcast();
  StreamSink<WelcomeApiAction> get eventSink => eventController.sink;
  Stream<WelcomeApiAction> get eventStream => eventController.stream;
  String videoLink = "";
  String get getVideoLink => videoLink;
  List<WelcomeModelData> list = [];

  WelcomeApi(token) {
    int i = 1;

    eventStream.listen(
      (event) async {
        if (event == WelcomeApiAction.fetch) {
          await getWelcome(token: token, i: i).then((value) {
            list += value.data.welcomeModelListData.list;

            dataSink.add(list);
          });
          i++;
        }

        if (event == WelcomeApiAction.update) {
          dataSink.add(list);
        }
      },
    );
  }

  setList(bool favourite, String snapshotlink, String snapshotPictureLink,
      String snapshotTitle) {
    for (var i = 0; i < list.length; i++) {
      if (list[i].isFavorite == favourite && list[i].link == snapshotlink) {
        list[i].setBool(false);
        log(list[i].title);
      }
    }
  }

  Future<WelcomeModel> getWelcome({required String token, int i = 1}) async {
    Response response = await get(
      Uri.parse(APIUrls().getWelcomeUrl + i.toString()),
      headers: {"token": token},
    );
    if (i == 1) {
      videoLink = jsonDecode(response.body)['data']['video'];
    }
    return WelcomeModel.fromMap(jsonDecode(response.body));
  }
}
