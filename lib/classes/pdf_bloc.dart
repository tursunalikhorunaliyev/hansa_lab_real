import 'dart:async';

import 'package:hansa_lab/apis/pdf_guide_api.dart';
import 'package:hansa_lab/apis/pdf_guide_model.dart';
import 'package:hansa_lab/apis/pdf_link_api.dart';
import 'package:hansa_lab/apis/pdf_link_model.dart';

final hansaLinkPDF = PDFLinkApi();
final handaReadPDF = PDFGuideAPI();

enum ActionBloc { show }

class PDFBLoC {
  final getAll = StreamController<String>.broadcast();
  final getAllAction = StreamController<ActionBloc>();
  StreamSink<String> get sink => getAll.sink;
  Stream<String> get stream => getAll.stream;
  StreamSink<ActionBloc> get sinkAction => getAllAction.sink;
  Stream<ActionBloc> get streamAction => getAllAction.stream;

  PDFBLoC() {
    streamAction.listen((event) async {
      if (event == ActionBloc.show) {
        sink.add(await getPDF());
      }
    });
  }

  Future<String> getPDF() async {
    PDFLinkModel pdfLinkModel = await hansaLinkPDF.getStores();
    PDFGuideModel pdfGuideAPI = await handaReadPDF
        .getStores(pdfLinkModel.data.guidesArchiveList.guides[0].link);
    String urlEnd = pdfGuideAPI.data.link.split("url=")[1];
    String urlStart = urlEnd.split("&")[0];
    sink.add(urlStart);
    return urlStart;
  }
}
