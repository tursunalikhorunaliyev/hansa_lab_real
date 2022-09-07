import 'dart:async';

enum ActionChange {
  textIconCard,
  personal,
  izboreny,
  statistik,
  nastroyka,
}

class BlocChangeProfile {
  final dataController = StreamController<ActionChange>.broadcast();
  StreamSink<ActionChange> get dataSink => dataController.sink;
  Stream<ActionChange> get dataStream => dataController.stream;
}
