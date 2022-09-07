import 'dart:async';

class BlocChangeTitle {
  final controller = StreamController<String>();
  StreamSink<String> get titleSink => controller.sink;
  Future<String> get titleStream => controller.stream.first;

  close() {
    controller.close();
  }
}

class BlocChangeTitleIndex {
  final controller = StreamController<int>();
  StreamSink<int> get titleSink => controller.sink;
  Stream<int> get titleStream => controller.stream;

  close() {
    controller.close();
  }
}
