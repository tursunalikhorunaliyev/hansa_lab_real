import 'dart:async';


class VideoControlBloc {
  final controller = StreamController<String>();
  StreamSink<String> get sink => controller.sink;
  Stream<String> get stream => controller.stream;
}
