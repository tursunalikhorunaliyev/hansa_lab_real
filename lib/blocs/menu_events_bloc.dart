import 'dart:async';

enum MenuActions {
  obuchayushieMaterial,
  prezintatsiya,
  stati,
  katalog,
  trening,
  video,
  oProyekt,
  welcome,
  presentAndArchive,
  chitatStati,
  trainingVideo,
  oKompanii,
  article,
  prezentFav
}

class MenuEventsBloC {
  Set<MenuActions> list = {MenuActions.welcome};
  /*  final List<MenuActions> menuActionsList = [MenuActions.welcome]; */
  final eventController = StreamController<MenuActions>.broadcast();
  StreamSink<MenuActions> get eventSink => eventController.sink;
  Stream<MenuActions> get eventStream => eventController.stream;

/*   final listActionsController = StreamController<List<MenuActions>>();
  StreamSink<List<MenuActions>> get listSink => listActionsController.sink;
  Stream<List<MenuActions>> get listStream => listActionsController.stream;
 */
  MenuEventsBloC() {
    eventStream.listen((event) {
      /*     menuActionsList.add(event); */
      /*  listSink.add(menuActionsList); */
      list.add(event);
    });
  }
}
