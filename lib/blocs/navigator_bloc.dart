import 'dart:async';

class NavigatorBloC{
  final controller = StreamController<List>();
  StreamSink<List> get sink => controller.sink;
  Stream<List> get stream => controller.stream;
}