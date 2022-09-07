import 'dart:async';

enum LoginAction {
  login,
  signin,
}

class LoginClickedBloc{
  final controller = StreamController<LoginAction>.broadcast();
  StreamSink<LoginAction> get sink => controller.sink;
  Stream<LoginAction> get stream => controller.stream;
}