// ignore_for_file: public_member_api_docs, sort_constructors_first
class PrezintatsiaModel {
  bool status;
  PrezintatsiaModelData data;

  PrezintatsiaModel({required this.status, required this.data});
  factory PrezintatsiaModel.fromMap(Map<String, dynamic> map) {
    return PrezintatsiaModel(
        status: map["status"],
        data: PrezintatsiaModelData.fromMap(map["data"]));
  }
}

class PrezintatsiaModelData {
  PrezintatsiaModelGuidesList guides;
  PrezintatsiaModelGuidesArchiveList guidesArchive;

  PrezintatsiaModelData({required this.guides, required this.guidesArchive});
  factory PrezintatsiaModelData.fromMap(Map<String, dynamic> map) {
    return PrezintatsiaModelData(
      guides: PrezintatsiaModelGuidesList.fromMap(map["guides"]),
      guidesArchive:
          PrezintatsiaModelGuidesArchiveList.fromMap(map["guidesArchive"]),
    );
  }
}

class PrezintatsiaModelGuidesArchiveList {
  List<PrezintatsiaModelGuidesArchiveItem> dataGuidesArchive;
  PrezintatsiaModelGuidesArchiveList({
    required this.dataGuidesArchive,
  });

  factory PrezintatsiaModelGuidesArchiveList.fromMap(List<dynamic> map) {
    return PrezintatsiaModelGuidesArchiveList(
        dataGuidesArchive: map
            .map((e) => PrezintatsiaModelGuidesArchiveItem.fromMap(e))
            .toList());
  }
}

class PrezintatsiaModelGuidesList {
  List<PrezintatsiaModelGuidesItem> dataGuides;

  PrezintatsiaModelGuidesList({required this.dataGuides});

  factory PrezintatsiaModelGuidesList.fromMap(List<dynamic> map) {
    return PrezintatsiaModelGuidesList(
      dataGuides:
          map.map((e) => PrezintatsiaModelGuidesItem.fromMap(e)).toList(),
    );
  }
}

class PrezintatsiaModelGuidesItem {
  String title;
  String pdfUrl;
  bool isFavourite;
  String pictureLink;
  String favouriteLink;
  String link;
  PrezintatsiaModelGuidesItem(
      {required this.title,
      required this.pdfUrl,
      required this.isFavourite,
      required this.pictureLink,
      required this.favouriteLink,
      required this.link});

  factory PrezintatsiaModelGuidesItem.fromMap(Map<String, dynamic> map) {
    return PrezintatsiaModelGuidesItem(
        title: map["title"],
        pdfUrl: map["PdfUrl"],
        isFavourite: map["isFavourite"],
        pictureLink: map["picture_link"],
        favouriteLink: map["favourite_link"],
        link: map["_link"]);
  }
}

class PrezintatsiaModelGuidesArchiveItem {
  String title;
  String pdfUrl;
  bool isFavourite;
  String pictureLink;
  String favouriteLink;
  String link;
  PrezintatsiaModelGuidesArchiveItem(
      {required this.title,
      required this.pdfUrl,
      required this.isFavourite,
      required this.pictureLink,
      required this.favouriteLink,
      required this.link});

  factory PrezintatsiaModelGuidesArchiveItem.fromMap(Map<String, dynamic> map) {
    return PrezintatsiaModelGuidesArchiveItem(
        title: map["title"],
        pdfUrl: map["PdfUrl"],
        isFavourite: map["isFavourite"],
        pictureLink: map["picture_link"],
        favouriteLink: map["favourite_link"],
        link: map["_link"]);
  }
}
