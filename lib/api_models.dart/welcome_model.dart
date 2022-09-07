class WelcomeModel {
  bool status;
  WelcomeData data;
  WelcomeModel({
    required this.status,
    required this.data,
  });

  factory WelcomeModel.fromMap(Map<String, dynamic> map) {
    return WelcomeModel(
      status: map['status'],
      data: WelcomeData.fromMap(
        map['data'],
      ),
    );
  }
}

class WelcomeData {
  WelcomeModelListData welcomeModelListData;
  WelcomeData({
    required this.welcomeModelListData,
  });

  factory WelcomeData.fromMap(Map<String, dynamic> map) {
    return WelcomeData(
      welcomeModelListData: WelcomeModelListData.fromMap(map['data']),
    );
  }
}

class WelcomeModelListData {
  List<WelcomeModelData> list;
  WelcomeModelListData({
    required this.list,
  });

  factory WelcomeModelListData.fromMap(List<dynamic> map) {
    return WelcomeModelListData(
      list: map.map((e) => WelcomeModelData.fromMap(e)).toList(),
    );
  }
}

class WelcomeModelData {
  String date;
  String title;
  bool isFavorite;
  String pictureLink;
  String favoriteLink;
  String link;
  setBool(bool fav) {
    isFavorite = fav;
  }

  bool get getFavorite => isFavorite;
  WelcomeModelData({
    required this.date,
    required this.title,
    required this.isFavorite,
    required this.pictureLink,
    required this.favoriteLink,
    required this.link,
  });

  factory WelcomeModelData.fromMap(Map<String, dynamic> map) {
    return WelcomeModelData(
      date: map['date'] as String,
      title: map['title'] as String,
      isFavorite: map['isFavourite'] as bool,
      pictureLink: map['picture_link'] as String,
      favoriteLink: map['favourite_link'] as String,
      link: map['_link'] as String,
    );
  }
}
