import 'dart:async';
import 'dart:convert';

import 'package:hansa_lab/api_models.dart/search_model.dart';
import 'package:http/http.dart' as http;

class SearchApi {
  Future<SearchModel> getSearchData(String token, String query) async {
    http.Response response = await http.post(
      Uri.parse('https://hansa-lab.ru/api/site/search'),
      headers: {"token": token},
      body: {"search": query},
    );
    return SearchModel.fromMap(jsonDecode(response.body));
  }
}
