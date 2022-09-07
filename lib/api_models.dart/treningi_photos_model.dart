class TreningiPhotosModel {
  bool status;
  TreningiphotosALlL data;

  TreningiPhotosModel({
    required this.status,
    required this.data,
  });

  factory TreningiPhotosModel.fromMap(Map<String, dynamic> map) {
    return TreningiPhotosModel(
      status: map['status'],
      data: TreningiphotosALlL.fromMap(map['data']),
    );
  }
}

class TreningiphotosALlL {
  TreningiPhotosdModelListData data;
  TreningiPhotosdModelSimilarListData similar;
  TreningiphotosALlL({
    required this.data,
    required this.similar,
  });
  factory TreningiphotosALlL.fromMap(Map<String, dynamic> map) {
    return TreningiphotosALlL(
        data: TreningiPhotosdModelListData.fromMap(map['data']),
        similar: TreningiPhotosdModelSimilarListData.fromMap(map['similar']));
  }
}

class TreningiPhotosdModelSimilarListData {
  List<TreningiPhotosdSimilarModelData> list;
  TreningiPhotosdModelSimilarListData({
    required this.list,
  });

  factory TreningiPhotosdModelSimilarListData.fromMap(List<dynamic> map) {
    return TreningiPhotosdModelSimilarListData(
      list: map.map((e) => TreningiPhotosdSimilarModelData.fromMap(e)).toList(),
    );
  }
}

class TreningiPhotosdModelListData {
  List<TreningiPhotosdModelData> list;
  TreningiPhotosdModelListData({
    required this.list,
  });

  factory TreningiPhotosdModelListData.fromMap(List<dynamic> map) {
    return TreningiPhotosdModelListData(
      list: map.map((e) => TreningiPhotosdModelData.fromMap(e)).toList(),
    );
  }
}

class TreningiPhotosdSimilarModelData {
  String title;
  String link;
  TreningiPhotosdSimilarModelData({
    required this.title,
    required this.link,
  });

  factory TreningiPhotosdSimilarModelData.fromMap(Map<String, dynamic> map) {
    return TreningiPhotosdSimilarModelData(
      title: map['title'] as String,
      link: map['_link'] as String,
    );
  }
}

class TreningiPhotosdModelData {
  String title;
  String pictureLink;
  TreningiPhotosdModelData({
    required this.title,
    required this.pictureLink,
  });

  factory TreningiPhotosdModelData.fromMap(Map<String, dynamic> map) {
    return TreningiPhotosdModelData(
      title: map['title'] as String,
      pictureLink: map['picture_link'] as String,
    );
  }
}
