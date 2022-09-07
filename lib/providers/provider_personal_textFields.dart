import 'package:flutter/material.dart';

class ProviderPersonalTextFields{
  final imyaController = TextEditingController();
  final familiyaController = TextEditingController();
  final dataRojdeniyaController = TextEditingController();
  final telefonController = TextEditingController();
  final doljnostController = TextEditingController();
  final gorodController = TextEditingController();
  final addressController = TextEditingController();
  final storeName = TextEditingController();
  String countryTypeId = "";
  String cityId = "";
  String jobId = "";
  String storeId = "";
  

  TextEditingController get getImyaController => imyaController;
  TextEditingController get getFamiliyaController => familiyaController;
  TextEditingController get getDataRojdeniyaController => dataRojdeniyaController;
  TextEditingController get getTelefonController => telefonController;
  TextEditingController get getDoljnostController => doljnostController;
  TextEditingController get getGorodController => gorodController;
  TextEditingController get getAddressController => addressController;
  TextEditingController get getStoreName => storeName;
  String get getCountryTypeId => countryTypeId;
  String get getCityId => cityId;
  String get getJobId => jobId;
  String get getStoreId => storeId;

   

}