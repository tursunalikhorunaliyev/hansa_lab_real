class IzbrannoeModel {
  bool status;
  IzbrannoeModelListData data;
  IzbrannoeModel({
    required this.status,
    required this.data,
  });

  factory IzbrannoeModel.fromMap(Map<String, dynamic> map) {
    return IzbrannoeModel(
      status: map['status'],
      data: IzbrannoeModelListData.fromMap(
        map['data'],
      ),
    );
  }
}

class IzbrannoeModelListData {
  List<IzbrannoeModelData> list;
  IzbrannoeModelListData({
    required this.list,
  });

  factory IzbrannoeModelListData.fromMap(List<dynamic> map) {
    return IzbrannoeModelListData(
      list: map.map((e) => IzbrannoeModelData.fromMap(e)).toList(),
    );
  }
}

class IzbrannoeModelData {
  String title;
  String pictureLink;
  String pdfUrl;
  int type;
  String link;
  String unlink;
  IzbrannoeModelData({
    required this.title,
    required this.pictureLink,
    required this.pdfUrl,
    required this.type,
    required this.link,
    required this.unlink,
  });

  factory IzbrannoeModelData.fromMap(Map<String, dynamic> map) {
    return IzbrannoeModelData(
      title: map["title"],
      pictureLink: map["picture_link"],
      pdfUrl: map["PdfUrl"] ?? "",
      type: map["type"],
      link: map["_link"],
      unlink: map["unlink"],
    );
  }
}
