
// ignore_for_file: public_member_api_docs, sort_constructors_first
class JobModel {
  bool status;
  Data data;
  JobModel({
    required this.status,
    required this.data,
  });

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      status: map['status'] as bool,
      data: Data.fromMap(map['data']),
    );
  }
}

class Data {
  List<JobModelData> jobModelData;
  Data({
    required this.jobModelData,
  });

  factory Data.fromMap(List<dynamic> map) {
    return Data(jobModelData: map.map((e) => JobModelData.fromMap(e)).toList());
  }
}

class JobModelData {
  int id;
  String name;
  JobModelData({
    required this.id,
    required this.name,
  });

  factory JobModelData.fromMap(Map<String, dynamic> map) {
    return JobModelData(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
