import 'dart:async';

class BlocForToken {
  final streamController = StreamController<String>.broadcast();
  Stream<String> get stream => streamController.stream;
  StreamSink<String> get sink => streamController.sink;
}
