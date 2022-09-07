class SearchModel {
  bool status;
  SearchModelListData data;
  SearchModel({required this.status, required this.data});
  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
        status: map['status'], data: SearchModelListData.fromMap(map['data']));
  }
}

class SearchModelListData {
  List<SearchModelData> data;
  SearchModelListData({
    required this.data,
  });

  factory SearchModelListData.fromMap(List<dynamic> map) {
    return SearchModelListData(
      data: map.map((e) => SearchModelData.fromMap(e)).toList(),
    );
  }
}

class SearchModelData {
  int type;
  String title;
  String picturelink;
  String link;
  SearchModelData({
    required this.type,
    required this.title,
    required this.picturelink,
    required this.link,
  });

  factory SearchModelData.fromMap(Map<String, dynamic> map) {
    return SearchModelData(
      type: map['type'] as int,
      title: map['title'] as String,
      picturelink: map['picture_link'] as String,
      link: map[(map['type'] as int != 4) ? '_link' : "video_link"] as String,
    );
  }
}
