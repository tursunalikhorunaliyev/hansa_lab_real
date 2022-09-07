import 'dart:convert';
import 'package:hansa_lab/apis/api_headers.dart';
import 'package:hansa_lab/apis/api_urls.dart';
import 'package:hansa_lab/apis/pdf_link_model.dart';
import 'package:http/http.dart' as http;

class PDFLinkApi {
  Future<PDFLinkModel> getStores() async {
    http.Response response = await http.get(
      Uri.parse(APIUrls().getPDFLink),
      headers: APIHeaders().token,
    );

    return PDFLinkModel.fromMap(jsonDecode(response.body));
  }
}
