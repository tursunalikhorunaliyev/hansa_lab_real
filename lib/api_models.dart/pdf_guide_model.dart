class PDFGuideModel {
  bool status;
  PDFGuideModelData data;
  PDFGuideModel({
    required this.status,
    required this.data,
  });

  factory PDFGuideModel.fromMap(Map<String, dynamic> map) {
    return PDFGuideModel(
      status: map['status'],
      data: PDFGuideModelData.fromMap(
        map['data'],
      ),
    );
  }
}

class PDFGuideModelData {
  String link;
  PDFGuideModelData({
    required this.link,
  });

  factory PDFGuideModelData.fromMap(Map<String, dynamic> map) {
    return PDFGuideModelData(
      link: map['_link'] as String,
    );
  }
}
