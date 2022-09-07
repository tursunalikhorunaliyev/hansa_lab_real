class FavouriteModel {
  bool status;
  bool data;
  FavouriteModel({required this.status, required this.data});
  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    return FavouriteModel(status: map["status"], data: map["data"]);
  }
}
