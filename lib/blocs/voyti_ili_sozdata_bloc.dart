import 'dart:async';

enum EntryType{
  voyti,
  sozdatAccaunt
}
class VoytiIliSozdatBloC{
  final controller = StreamController<EntryType>();
  StreamSink<EntryType> get actionSink => controller.sink;
  Stream<EntryType> get actionStream => controller.stream;
}