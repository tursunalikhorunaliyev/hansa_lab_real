import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hansa_lab/api_models.dart/training_model.dart';

class TrainingAPIBloc {
  Future<TrainingModel> getTrainingData(token) async {
    http.Response response = await http.get(
      Uri.parse("https://hansa-lab.ru/api/site/training"),
      headers: {"token": token},
    );
    return TrainingModel.fromMap(jsonDecode(response.body));
  }
}
