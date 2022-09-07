// ignore_for_file: public_member_api_docs, sort_constructors_first
class ObucheniyaModel {
  bool status;
  Data data;
  ObucheniyaModel({
    required this.status,
    required this.data,
  });

  factory ObucheniyaModel.fromMap(Map<String, dynamic> map) {
    return ObucheniyaModel(
      status: map['status'],
      data: Data.fromMap(map['data']),
    );
  }
}

class Data {
  ListGuides listGuides;
  ListArchiveGuides listArchiveGuides;
  Data({
    required this.listGuides,
    required this.listArchiveGuides,
  });

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      listGuides: ListGuides.fromMap(map['guides']),
      listArchiveGuides: ListArchiveGuides.fromMap(map['guidesArchive']),
    );
  }
}

class ListGuides {
  List<Guides> list;
  ListGuides({
    required this.list,
  });

  factory ListGuides.fromMap(List<dynamic> map) {
    return ListGuides(list: map.map((e) => Guides.fromMap(e)).toList());
  }
}

class Guides {
  String title;
  String pdfUrl;
  bool isFavourite;
  String pictureLink;
  String favouriteLink;
  String link;

  Guides({
    required this.title,
    required this.pdfUrl,
    required this.isFavourite,
    required this.pictureLink,
    required this.favouriteLink,
    required this.link,
  });

  factory Guides.fromMap(Map<String, dynamic> map) {
    return Guides(
      title: map['title'] as String,
      pdfUrl: map['PdfUrl'] as String,
      isFavourite: map['isFavourite'] as bool,
      pictureLink: map['picture_link'] as String,
      favouriteLink: map['favourite_link'] as String,
      link: map['_link'] as String,
    );
  }
}

class ListArchiveGuides {
  List<ArchiveGuides> list;
  ListArchiveGuides({
    required this.list,
  });

  factory ListArchiveGuides.fromMap(List<dynamic> map) {
    return ListArchiveGuides(
        list: map.map((e) => ArchiveGuides.fromMap(e)).toList());
  }
}

class ArchiveGuides {
  String title;
  String pdfUrl;
  bool isFavourite;
  String pictureLink;
  String favouriteLink;
  String link;
  ArchiveGuides({
    required this.title,
    required this.pdfUrl,
    required this.isFavourite,
    required this.pictureLink,
    required this.favouriteLink,
    required this.link,
  });

  factory ArchiveGuides.fromMap(Map<String, dynamic> map) {
    return ArchiveGuides(
      title: map['title'] as String,
      pdfUrl: map['PdfUrl'] as String,
      isFavourite: map['isFavourite'] as bool,
      pictureLink: map['picture_link'] as String,
      favouriteLink: map['favourite_link'] as String,
      link: map['_link'] as String,
    );
  }
}
