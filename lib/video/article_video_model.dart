class ArticleVideoModel {
  bool? status;
  Data? data;

  ArticleVideoModel({
    this.status,
    this.data,
  });

  factory ArticleVideoModel.fromJson(Map<String, dynamic> json) => ArticleVideoModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  String? title;
  String? pictureLink;
  String? videoLink;

  Data({
    this.title,
    this.pictureLink,
    this.videoLink,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    title: json["title"],
    pictureLink: json["picture_link"],
    videoLink: json["video_link"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "picture_link": pictureLink,
    "video_link": videoLink,
  };
}
