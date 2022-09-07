

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CatalogModel {
  bool status;
  CatalogModelData data;
  CatalogModel({
    required this.status,
    required this.data,
  });
  factory CatalogModel.fromMap(Map<String, dynamic> map) {
    return CatalogModel(
      status: map['status'],
      data: CatalogModelData.fromMap(map['data']),
    );
  }
}

class CatalogModelData {
  CatalogGuidesList guides;
  CatalogGuidesArchiveList guidesArchive;
  CatalogModelData({
    required this.guides,
    required this.guidesArchive,
  });

  factory CatalogModelData.fromMap(Map<String, dynamic> map) {
    return CatalogModelData(
      guides: CatalogGuidesList.fromMap(map['guides']),
      guidesArchive: CatalogGuidesArchiveList.fromMap(map['guidesArchive']),
    );
  }
}

class CatalogGuidesList {
  List<CatalogGuide> list;
  CatalogGuidesList({
    required this.list,
  });

  factory CatalogGuidesList.fromMap(List<dynamic> list) {
    return CatalogGuidesList(
        list: list.map((e) => CatalogGuide.fromMap(e)).toList());
  }
}

class CatalogGuidesArchiveList {
  List<CatalogGuidesArchive> list;
  CatalogGuidesArchiveList({
    required this.list,
  });

  factory CatalogGuidesArchiveList.fromMap(List<dynamic> list) {
    return CatalogGuidesArchiveList(
        list: list.map((e) => CatalogGuidesArchive.fromMap(e)).toList());
  }
}

class CatalogGuide {
  String title;
  String pdfUrl;
  bool isFavourite;
  String pictureLink;
  String favoutriteLink;
  String link;
  CatalogGuide({
    required this.title,
    required this.pdfUrl,
    required this.isFavourite,
    required this.pictureLink,
    required this.favoutriteLink,
    required this.link,
  });

  factory CatalogGuide.fromMap(Map<String, dynamic> map) {
    return CatalogGuide(
      title: map['title'] as String,
      pdfUrl: map['PdfUrl'] as String,
      isFavourite: map['isFavourite'] as bool,
      pictureLink: map['picture_link'] as String,
      favoutriteLink: map['favourite_link'] as String,
      link: map['_link'] as String,
    );
  }
}

class CatalogGuidesArchive {
  String title;
  String pdfUrl;
  bool isFavourite;
  String pictureLink;
  String favoutriteLink;
  String link;
  CatalogGuidesArchive({
    required this.title,
    required this.pdfUrl,
    required this.isFavourite,
    required this.pictureLink,
    required this.favoutriteLink,
    required this.link,
  });

  factory CatalogGuidesArchive.fromMap(Map<String, dynamic> map) {
    return CatalogGuidesArchive(
      title: map['title'] as String,
      pdfUrl: map['PdfUrl'] as String,
      isFavourite: map['isFavourite'] as bool,
      pictureLink: map['picture_link'] as String,
      favoutriteLink: map['favourite_link'] as String,
      link: map['_link'] as String,
    );
  }
}
