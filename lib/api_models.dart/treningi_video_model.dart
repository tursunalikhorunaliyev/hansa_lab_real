class TreningiVideoModel {
  bool status;
  TreningiVideoSplitter data;
  TreningiVideoModel({required this.data, required this.status});
  factory TreningiVideoModel.fromMap(Map<String, dynamic> map) {
    return TreningiVideoModel(
      status: map['status'],
      data: TreningiVideoSplitter.fromMap(map['data']),
    );
  }
}

class TreningiVideoSplitter {
  TreningiVideoModelListData data;
  TreningiVideoSimilarModelListData similar;
  TreningiVideoSplitter({
    required this.data,
    required this.similar,
  });

  factory TreningiVideoSplitter.fromMap(Map<String, dynamic> map) {
    return TreningiVideoSplitter(
      data: TreningiVideoModelListData.fromMap(map['data']),
      similar: TreningiVideoSimilarModelListData.fromMap(map['similar']),
    );
  }
}

class TreningiVideoSimilarModelListData {
  List<TreningiVideoSimilarModelData> data;
  TreningiVideoSimilarModelListData({
    required this.data,
  });

  factory TreningiVideoSimilarModelListData.fromMap(List<dynamic> map) {
    return TreningiVideoSimilarModelListData(
      data: map.map((e) => TreningiVideoSimilarModelData.fromMap(e)).toList(),
    );
  }
}

class TreningiVideoSimilarModelData {
  String title;
  String link;
  TreningiVideoSimilarModelData({
    required this.title,
    required this.link,
  });

  factory TreningiVideoSimilarModelData.fromMap(Map<String, dynamic> map) {
    return TreningiVideoSimilarModelData(
      title: map['title'] as String,
      link: map['_link'] as String,
    );
  }
}

class TreningiVideoModelListData {
  List<TreningiVideoModelData> data;
  TreningiVideoModelListData({
    required this.data,
  });

  factory TreningiVideoModelListData.fromMap(List<dynamic> map) {
    return TreningiVideoModelListData(
      data: map.map((e) => TreningiVideoModelData.fromMap(e)).toList(),
    );
  }
}

class TreningiVideoModelData {
  String title;
  String pictureLink;
  String videoLink;
  TreningiVideoModelData({
    required this.title,
    required this.pictureLink,
    required this.videoLink,
  });

  factory TreningiVideoModelData.fromMap(Map<String, dynamic> map) {
    return TreningiVideoModelData(
      title: map['title'] as String,
      pictureLink: map['picture_link'] as String,
      videoLink: map['video_link'] as String,
    );
  }
}
