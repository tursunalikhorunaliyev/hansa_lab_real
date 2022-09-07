import 'dart:async';

class ProgressButtonAnmationBLoC {
  final eventController = StreamController<bool>();

  StreamSink<bool> get sink => eventController.sink;
  Stream<bool> get stream => eventController.stream;
}
