class StoreModel {
  bool status;
  Data data;
  StoreModel({
    required this.status,
    required this.data,
  });

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      status: map['status'] as bool,
      data: Data.fromMap(
        map['data'],
      ),
    );
  }
}

class Data {
  List<StoreModelData> list;
  Data({
    required this.list,
  });

  factory Data.fromMap(List<dynamic> map) {
    return Data(list: map.map((e) => StoreModelData.fromMap(e)).toList());
  }
}

class StoreModelData {
  int id;
  String name;
  StoreModelData({
    required this.id,
    required this.name,
  });

  factory StoreModelData.fromMap(Map<String, dynamic> map) {
    return StoreModelData(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
