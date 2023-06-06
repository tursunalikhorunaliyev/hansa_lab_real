import 'dart:convert';

QrCodeResponseModel qrCodeResponseModelFromJson(String str) => QrCodeResponseModel.fromJson(json.decode(str));

String qrCodeResponseModelToJson(QrCodeResponseModel data) => json.encode(data.toJson());

class QrCodeResponseModel {
  QrCodeResponseModel({
    this.status,
    this.data,
  });

  bool? status;
  Data? data;

  factory QrCodeResponseModel.fromJson(Map<String, dynamic> json) => QrCodeResponseModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.title,
    this.url,
  });

  String? title;
  String? url;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    title: json["title"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
  };
}
