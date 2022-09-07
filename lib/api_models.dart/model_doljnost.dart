
class ModelDoljnostMain {
  bool status;
  ModelDoljnost2 modelDoljnost2;
  ModelDoljnostMain({
    required this.status,
    required this.modelDoljnost2,
  });

  factory ModelDoljnostMain.fromMap(Map<String, dynamic> map) {
    return ModelDoljnostMain(
      status: map['status'],
      modelDoljnost2: ModelDoljnost2.fromMap(map['data']),
    );
  }
}

class ModelDoljnost2 {
  List<ModelDoljnost1> list;
  ModelDoljnost2({
    required this.list,
  });

  factory ModelDoljnost2.fromMap(List<dynamic> map) {
    return ModelDoljnost2(
        list: map.map((e) => ModelDoljnost1.fromMap(e)).toList());
  }
}

class ModelDoljnost1 {
  int id;
  String name;
  ModelDoljnost1({
    required this.id,
    required this.name,
  });

  factory ModelDoljnost1.fromMap(Map<String, dynamic> map) {
    return ModelDoljnost1(
      id: map['id'],
      name: map['name'],
    );
  }
}
