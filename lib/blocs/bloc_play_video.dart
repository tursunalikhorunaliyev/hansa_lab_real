import 'dart:async';

class BlocPlayVideo {
  final controller = StreamController<List>.broadcast();
  StreamSink<List> get sink => controller.sink;
  Stream<List> get stream => controller.stream;
}