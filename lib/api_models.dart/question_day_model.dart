import 'dart:convert';

QuestionDay questionDayFromJson(String str) => QuestionDay.fromJson(json.decode(str));

String questionDayToJson(QuestionDay data) => json.encode(data.toJson());

class QuestionDay {
  QuestionDay({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory QuestionDay.fromJson(Map<String, dynamic> json) => QuestionDay(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.question,
    required this.answers,
    required this.show,
  });

  Question question;
  List<Answer> answers;
  bool show;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    question: Question.fromJson(json["question"]),
    answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
    show: json["show"],
  );

  Map<String, dynamic> toJson() => {
    "question": question.toJson(),
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
    "show": show,
  };
}

class Answer {
  Answer({
    required this.number,
    required this.text,
    required this.isRight,
  });

  int number;
  String text;
  int isRight;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    number: json["number"],
    text: json["text"],
    isRight: json["is_right"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "text": text,
    "is_right": isRight,
  };
}

class Question {
  Question({
    required this.id,
    required this.text,
  });

  int id;
  String text;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
