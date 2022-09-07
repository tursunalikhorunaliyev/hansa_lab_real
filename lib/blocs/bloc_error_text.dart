import 'dart:async';

class BlocErrorText{
  final dataController = StreamController<String>.broadcast();
  StreamSink<String> get dataSink => dataController.sink;
  Stream<String> get dataStream => dataController.stream;
}