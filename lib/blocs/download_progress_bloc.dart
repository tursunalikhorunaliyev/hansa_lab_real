
import 'dart:async';

class DownloadProgressFileBloc{
  final controller = StreamController<double>.broadcast();
  Stream<double> get stream => controller.stream;
  StreamSink<double> get streamSink => controller.sink;
}