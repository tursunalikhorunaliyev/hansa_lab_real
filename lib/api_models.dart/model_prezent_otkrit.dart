
class ModelPrezentOtkritMain {
  bool status;
  ModelPrezentOtkritList modelPrezentOtkritList;
  ModelPrezentOtkritMain({
    required this.status,
    required this.modelPrezentOtkritList,
  });



  factory ModelPrezentOtkritMain.fromMap(Map<String, dynamic> map) {
    return ModelPrezentOtkritMain(
      status: map['status'],
      modelPrezentOtkritList: ModelPrezentOtkritList.fromMap(map['data']),
    );
  }


}

class ModelPrezentOtkritList {
  List<ModelPrezentOtkritDetails> list;
  ModelPrezentOtkritList({
    required this.list,
  });



  factory ModelPrezentOtkritList.fromMap(List<dynamic> map) {
    return ModelPrezentOtkritList(
      list: map.map((e) => ModelPrezentOtkritDetails.fromMap(e)).toList()
    );
  }


}

class ModelPrezentOtkritDetails {
  String title;
  String pictureLink;
  String link;
  ModelPrezentOtkritDetails({
    required this.title,
    required this.pictureLink,
    required this.link,
  });

  factory ModelPrezentOtkritDetails.fromMap(Map<String, dynamic> map) {
    return ModelPrezentOtkritDetails(
      title: map['title'],
      pictureLink: map['picture_link'],
      link: map['_link'],
    );
  }
}
