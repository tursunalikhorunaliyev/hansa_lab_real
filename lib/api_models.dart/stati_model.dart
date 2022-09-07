class StatiModel {
  bool status;
  ListStatiModel list;
  StatiModel({required this.status, required this.list});
  factory StatiModel.fromJson(Map<String, dynamic> map) {
    return StatiModel(
        status: map["status"], list: ListStatiModel.fromJson(map["data"]));
  }
}

class ListStatiModel {
  List<StatiModelApi> list;
  ListStatiModel({required this.list});

  factory ListStatiModel.fromJson(List<dynamic> map) {
    return ListStatiModel(
        list: map.map((e) => StatiModelApi.fromJson(e)).toList());
  }
}

class StatiModelApi {
  String title;
  String link;

  StatiModelApi({required this.title, required this.link});

  factory StatiModelApi.fromJson(Map<String, dynamic> map) {
    return StatiModelApi(title: map["title"], link: map["_link"]);
  }
}
