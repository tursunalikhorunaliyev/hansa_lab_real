import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/qr_code_model.dart';
import 'package:http/http.dart' as http;


class QrCodeBloc {
  final controller = StreamController<QrCodeResponseModel>.broadcast();

  Stream<QrCodeResponseModel> get stream => controller.stream;
  StreamSink<QrCodeResponseModel> get sink => controller.sink;


  Future<QrCodeResponseModel> getQrCodeResponse(token ,qrcode) async {

    var headers = {'token': token.toString()};
    var request = http.Request('GET', Uri.parse("https://hansa-lab.ru/api/qr-code/presentation?qr-code=$qrcode"));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    Map<String, dynamic>? map;
    if (response.statusCode == 200) {
      await response.stream
          .bytesToString()
          .then((value) => map = jsonDecode(value) as Map<String, dynamic>);
    }

    return QrCodeResponseModel.fromJson(map!);
  }
}
