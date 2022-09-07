

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CountryModel {
  bool status;
  Data data;
  CountryModel({
    required this.status,
    required this.data,
  });

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      status: map['status'],
      data: Data.fromMap(
        map['data'],
      ),
    );
  }
}

class Data {
  List<CountryModelData> list;
  Data({
    required this.list,
  });

  factory Data.fromMap(List<dynamic> map) {
    return Data(list: map.map((e) => CountryModelData.fromMap(e)).toList());
  }
}

class CountryModelData {
  int id;
  String name;
  CountryModelData({
    required this.id,
    required this.name,
  });

  factory CountryModelData.fromMap(Map<String, dynamic> map) {
    return CountryModelData(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
