
class ModelOKompaniyaMain {
  bool status;
  Data data;
  ModelOKompaniyaMain({
    required this.status,
    required this.data,
  });



  factory ModelOKompaniyaMain.fromMap(Map<String, dynamic> map) {
    return ModelOKompaniyaMain(
      status: map['status'],
      data: Data.fromMap(map['data']),
    );
  }


}

class Data {
  String title;
  List<String> list;
  Data({
    required this.title,
    required this.list,
  });
  



  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      title: map['title'],
      list: List<String>.from(map['body']),
    );
  }


}
