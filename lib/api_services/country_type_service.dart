import 'dart:convert';

import 'package:hansa_lab/api_models.dart/country_type_model.dart';
import 'package:hansa_lab/api_services/api_urls.dart';
import 'package:http/http.dart';

class CountryTypeService{

   
   Future<List> getCountryTypes() async { 
    Response response = await get(Uri.parse(APIUrls().getCountryTypes));
    return CountryTypeModel.fromMap(jsonDecode(response.body)).data.countryTypes;
  }
}