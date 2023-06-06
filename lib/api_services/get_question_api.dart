import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../api_models.dart/question_day_model.dart';

enum GetQuestionEnum { get, set }

class GetQuestionApi {
  final getQuestionDataController = StreamController<QuestionDay>.broadcast();

  StreamSink<QuestionDay> get dataSink => getQuestionDataController.sink;

  Stream<QuestionDay> get getQuestionData => getQuestionDataController.stream;
  final eventController = StreamController<GetQuestionEnum>.broadcast();

  StreamSink<GetQuestionEnum> get eventSink => eventController.sink;

  Stream<GetQuestionEnum> get eventStream => eventController.stream;

  GetQuestionApi(token, [int? answer, int? questionId]) {
    eventStream.listen((event) async {
      if (event == GetQuestionEnum.get) {
        dataSink.add(await getQuestion(token));
      }
    });
  }

  Future<QuestionDay> getQuestion(String token) async {
    if (kDebugMode) {
      print("token: $token");
    }
    Response response = await get(
      Uri.parse("https://hansa-lab.ru/api/question/day"),
      headers: {"token": token},
    );
    return QuestionDay.fromJson(jsonDecode(response.body));
  }

  Future<void> setQuestion(String token, int answer, int questionId) async {
    http.post(
      Uri.parse("https://hansa-lab.ru/api/question/answer"),
      headers: {
        "token": token,
      },
      body: {
        "id": questionId.toString(),
        "answer": answer.toString(),
      },
    );
  }
}
