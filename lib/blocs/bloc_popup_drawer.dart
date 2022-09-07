import 'dart:async';

class BlocPopupDrawer {
  final dataController = StreamController<double>();

  StreamSink<double> get dataSink => dataController.sink;
  Stream<double> get dataStream => dataController.stream;
}
