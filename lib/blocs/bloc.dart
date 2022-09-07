import 'dart:async';

class BlocAnim {
  final controller = StreamController<bool>.broadcast();

  StreamSink<bool> get sink => controller.sink;
  Stream<bool> get stream => controller.stream;
  BlocAnim() {
    sink.add(true);
  }
}
