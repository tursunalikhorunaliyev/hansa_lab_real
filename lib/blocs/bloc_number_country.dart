import 'dart:async';

enum EnumCuntryNumber { rus, kazak, armen }

class BlocNumberCountry {
  final streamController = StreamController<EnumCuntryNumber>.broadcast();
  Stream<EnumCuntryNumber> get stream => streamController.stream;
  StreamSink<EnumCuntryNumber> get sink => streamController.sink;
}
