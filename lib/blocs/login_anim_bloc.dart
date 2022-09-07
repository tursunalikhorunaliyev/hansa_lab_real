import 'dart:async';

class LoginAnimBloc{
  final controller = StreamController<double>.broadcast();
  StreamSink<double> get sink => controller.sink;
  Stream<double> get stream => controller.stream;
}