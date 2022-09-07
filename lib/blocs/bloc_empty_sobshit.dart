import 'dart:async';

class BlocEmptySobshit {
  final dataController = StreamController<bool>.broadcast();
  StreamSink<bool> get dataSink => dataController.sink;
  Stream<bool> get dataStream => dataController.stream;
}
