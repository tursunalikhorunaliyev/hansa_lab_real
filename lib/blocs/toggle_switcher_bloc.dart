import 'dart:async';

class ToggleSwitcherBloc {
  final dataController = StreamController<bool>.broadcast();
  StreamSink<bool> get dataSink => dataController.sink;
  Stream<bool> get dataStream => dataController.stream;
}