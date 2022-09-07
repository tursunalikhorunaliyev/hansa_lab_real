class ArticleModel {
  bool status;
  ArticleModelBody article;
  ArticleModel({required this.status, required this.article});

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
        status: map["status"], article: ArticleModelBody.fromMap(map["data"]));
  }
}

class ArticleModelBody {
  String title;
  String body;
  String puctureLink;
  ArticleModelBody(
      {required this.title, required this.body, required this.puctureLink});

  factory ArticleModelBody.fromMap(Map<String, dynamic> map) {
    return ArticleModelBody(
        title: map["title"],
        body: map["body"],
        puctureLink: map["pucture_link"]);
  }
}
