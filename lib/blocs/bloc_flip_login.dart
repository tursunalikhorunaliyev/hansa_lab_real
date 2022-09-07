import 'dart:async';

class BlocFlipLogin {
  final controller = StreamController<bool>();
  StreamSink<bool> get sink => controller.sink;
  Stream<bool> get stream => controller.stream;
}
