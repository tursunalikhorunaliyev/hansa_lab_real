class PDFLinkModel {
  bool status;
  PDFLinkModelData data;
  PDFLinkModel({
    required this.status,
    required this.data,
  });

  factory PDFLinkModel.fromMap(Map<String, dynamic> map) {
    return PDFLinkModel(
      status: map['status'],
      data: PDFLinkModelData.fromMap(map['data']),
    );
  }
}

class PDFLinkModelData {
  PDFGuideList guideList;
  PDFGuidesArchiveList guidesArchiveList;
  PDFLinkModelData({
    required this.guideList,
    required this.guidesArchiveList,
  });

  factory PDFLinkModelData.fromMap(Map<String, dynamic> map) {
    return PDFLinkModelData(
      guideList: PDFGuideList.fromMap(map['guides']),
      guidesArchiveList: PDFGuidesArchiveList.fromMap(map['guidesArchive']),
    );
  }
}

class PDFGuideList {
  List<PDFLinkModelGuides> guides;
  PDFGuideList({
    required this.guides,
  });

  factory PDFGuideList.fromMap(List<dynamic> map) {
    return PDFGuideList(
      guides: map.map((e) => PDFLinkModelGuides.fromMap(e)).toList(),
    );
  }
}

class PDFGuidesArchiveList {
  List<PDFLinkModelGuidesArchive> guides;
  PDFGuidesArchiveList({
    required this.guides,
  });

  factory PDFGuidesArchiveList.fromMap(List<dynamic> map) {
    return PDFGuidesArchiveList(
      guides: map.map((e) => PDFLinkModelGuidesArchive.fromMap(e)).toList(),
    );
  }
}

class PDFLinkModelGuides {
  String title;
  String pdfUrl;
  String pictureLink;
  String link;
  PDFLinkModelGuides({
    required this.title,
    required this.pdfUrl,
    required this.pictureLink,
    required this.link,
  });

  factory PDFLinkModelGuides.fromMap(Map<String, dynamic> map) {
    return PDFLinkModelGuides(
      title: map['title'] as String,
      pdfUrl: map['PdfUrl'] as String,
      pictureLink: map['picture_link'] as String,
      link: map['_link'] as String,
    );
  }
}

class PDFLinkModelGuidesArchive {
  String title;
  String pdfUrl;
  String pictureLink;
  String link;
  PDFLinkModelGuidesArchive({
    required this.title,
    required this.pdfUrl,
    required this.pictureLink,
    required this.link,
  });

  factory PDFLinkModelGuidesArchive.fromMap(Map<String, dynamic> map) {
    return PDFLinkModelGuidesArchive(
      title: map['title'] as String,
      pdfUrl: map['PdfUrl'] as String,
      pictureLink: map['picture_link'] as String,
      link: map['_link'] as String,
    );
  }
}
