class CountryTypeModel {
  bool status;
  CountryTypeModelData data;
  CountryTypeModel({
    required this.status,
    required this.data,
  });

  factory CountryTypeModel.fromMap(Map<String, dynamic> map) {
    return CountryTypeModel(
      status: map['status'],
      data: CountryTypeModelData.fromMap(
        map['data'],
      ),
    );
  }
}

class CountryTypeModelData {
  List<String> countryTypes;
  CountryTypeModelData({
    required this.countryTypes,
  });

  factory CountryTypeModelData.fromMap(Map<String, dynamic> map) {
    List<String> list = [];
    List<String> keys = [];
    for (var element in map.keys) {
      keys.add(element);
      list.add(map[element]);
    }
    return CountryTypeModelData(
      countryTypes: list,
    );
  }
}
