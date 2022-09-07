class VideoMainOne {
  bool status;
  VideoListData videoListData;
  VideoMainOne({
    required this.status,
    required this.videoListData,
  });

  factory VideoMainOne.fromMap(Map<String, dynamic> map) {
    return VideoMainOne(
      status: map['status'],
      videoListData: VideoListData.fromMap(map['data']),
    );
  }
}

class VideoListData {
  List<VideoMain> list;
  VideoListData({
    required this.list,
  });

  factory VideoListData.fromMap(List<dynamic> map) {
    return VideoListData(
      list: map.map((e) => VideoMain.fromMap(e)).toList(),
    );
  }
}

class VideoMain {
  String title;
  VideoList data;
  VideoMain({
    required this.title,
    required this.data,
  });

  factory VideoMain.fromMap(Map<String, dynamic> map) {
    return VideoMain(
      title: map['title'],
      data: VideoList.fromMap(map["data"]),
    );
  }
}

class VideoList {
  List<VideoDetails> list;
  VideoList({
    required this.list,
  });

  factory VideoList.fromMap(List<dynamic> map) {
    return VideoList(list: map.map((e) => VideoDetails.fromMap(e)).toList());
  }
}

class VideoDetails {
  String title;
  String pictureLink;
  String videoLink;
  VideoDetails({
    required this.title,
    required this.pictureLink,
    required this.videoLink,
  });

  factory VideoDetails.fromMap(Map<String, dynamic> map) {
    return VideoDetails(
      title: map['title'],
      pictureLink: map['picture_link'],
      videoLink: map['video_link'],
    );
  }
}
