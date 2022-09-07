class StatiComentModel {
  bool status;
  StatiCommentModelData data;
  StatiComentModel({
    required this.status,
    required this.data,
  });

  factory StatiComentModel.fromMap(Map<String, dynamic> map) {
    return StatiComentModel(
      status: map['status'],
      data: StatiCommentModelData.fromMap(map['data']),
    );
  }
}

class StatiCommentModelData {
  List<StatiCommentModelItems> list;
  StatiCommentModelData({
    required this.list,
  });

  factory StatiCommentModelData.fromMap(List<dynamic> map) {
    return StatiCommentModelData(
        list: map.map((e) => StatiCommentModelItems.fromMap(e)).toList());
  }
}

class StatiCommentModelItems {
  String fullname;
  String date;
  String body;
  String pictureLink;
  String rang;
  StatiCommentModelItems({
    required this.fullname,
    required this.date,
    required this.body,
    required this.pictureLink,
    required this.rang,
  });

  factory StatiCommentModelItems.fromMap(Map<String, dynamic> map) {
    return StatiCommentModelItems(
      fullname: map['fullname'],
      date: map['date'],
      body: map['body'],
      pictureLink: map['picture_link'],
      rang: map['rang'].toString(),
    );
  }
}
