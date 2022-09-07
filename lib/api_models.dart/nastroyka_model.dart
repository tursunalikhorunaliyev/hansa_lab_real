
// ignore_for_file: public_member_api_docs, sort_constructors_first

class NastroykaModel {
  bool status;
  DataNastroyka data;
  NastroykaModel({
    required this.status,
    required this.data,
  });

  factory NastroykaModel.fromMap(Map<String, dynamic> map) {
    return NastroykaModel(
      status: map['status'] as bool,
      data: DataNastroyka.fromMap(map['data']),
    );
  }
}

class DataNastroyka {
  int subscribe;
  DataNastroyka({
    required this.subscribe,
  });

  factory DataNastroyka.fromMap(Map<String, dynamic> map) {
    return DataNastroyka(
      subscribe: map['subscribe'] as int,
    );
  }
}
