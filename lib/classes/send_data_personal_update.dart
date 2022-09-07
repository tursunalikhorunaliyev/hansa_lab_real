class SendDataPersonalUpdate {
  bool onTap = false;
  late int doljnostId;
  late int gorodId;
  late int magazinId;

  setDoljnostId(int id) {
    doljnostId = id;
  }

  setGorodId(int id) {
    gorodId = id;
  }

  setMagazinId(int id) {
    magazinId = id;
  }

  setTap(bool tap) {
    onTap = tap;
  }

  int get getDoljnostId => doljnostId;
  int get getGorodId => gorodId;
  int get getMagazinId => magazinId;
  bool get getOnTap => onTap;
}
