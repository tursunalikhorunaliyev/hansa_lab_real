
class ModelMagazinMain {
  bool status;
  ModelMagazin2 modelMagazin2;
  ModelMagazinMain({
    required this.status,
    required this.modelMagazin2,
  });

  factory ModelMagazinMain.fromMap(Map<String, dynamic> map) {
    return ModelMagazinMain(
      status: map['status'],
      modelMagazin2: ModelMagazin2.fromMap(map['data']),
    );
  }
}

class ModelMagazin2 {
  List<ModelMagazin1> list;
  ModelMagazin2({
    required this.list,
  });

  factory ModelMagazin2.fromMap(List<dynamic> map) {
    return ModelMagazin2(
        list: map.map((e) => ModelMagazin1.fromMap(e)).toList());
  }
}

class ModelMagazin1 {
  int id;
  String name;
  ModelMagazin1({
    required this.id,
    required this.name,
  });

  factory ModelMagazin1.fromMap(Map<String, dynamic> map) {
    return ModelMagazin1(
      id: map['id'],
      name: map['name'],
    );
  }
}
