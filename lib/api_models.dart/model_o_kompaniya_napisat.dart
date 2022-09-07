
class ModelOKompaniyaNapisatMain {
  bool status;
  bool data;
  ModelOKompaniyaNapisatMain({
    required this.status,
    required this.data,
  });

  factory ModelOKompaniyaNapisatMain.fromMap(Map<String, dynamic> map) {
    return ModelOKompaniyaNapisatMain(
      status: map['status'],
      data: map['data'],
    );
  }
}
