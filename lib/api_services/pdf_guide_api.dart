import 'dart:convert';
import 'package:hansa_lab/apis/api_headers.dart';
import 'package:hansa_lab/apis/api_urls.dart';
import 'package:hansa_lab/apis/pdf_guide_model.dart';
import 'package:http/http.dart';

class PDFGuideAPI {
  Future<PDFGuideModel> getStores(String pdfLink) async {
    Response response = await post(
      Uri.parse(APIUrls().hansaAPIUrl + pdfLink),
      headers: APIHeaders().token,
    );
    return PDFGuideModel.fromMap(jsonDecode(response.body));
  }
}
