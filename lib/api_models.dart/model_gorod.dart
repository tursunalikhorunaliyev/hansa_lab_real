
class ModelGorodMain {
  bool status;
  ModelGorod2 modelGorod2;
  ModelGorodMain({
    required this.status,
    required this.modelGorod2,
  });

  factory ModelGorodMain.fromMap(Map<String, dynamic> map) {
    return ModelGorodMain(
      status: map['status'],
      modelGorod2: ModelGorod2.fromMap(map['data']),
    );
  }
}

class ModelGorod2 {
  List<ModelGorod1> list;
  ModelGorod2({
    required this.list,
  });

  factory ModelGorod2.fromMap(List<dynamic> map) {
    return ModelGorod2(
        list: map.map((e) => ModelGorod1.fromMap(e)).toList());
  }
}

class ModelGorod1 {
  int id;
  String name;
  ModelGorod1({
    required this.id,
    required this.name,
  });

  factory ModelGorod1.fromMap(Map<String, dynamic> map) {
    return ModelGorod1(
      id: map['id'],
      name: map['name'],
    );
  }
}
