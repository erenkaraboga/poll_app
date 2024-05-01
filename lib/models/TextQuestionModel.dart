class QuestionResponseModel {
  List<Question>? questions;

  QuestionResponseModel({this.questions});

  QuestionResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = <Question>[];
      json['questions'].forEach((v) {
        questions!.add(new Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Question {
  String? type;
  String? title;
  String? singleAnswer;
  List<String>? options;
  List<String>? answer;

  Question(
      {this.type, this.title, this.singleAnswer, this.options, this.answer});

  Question.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    singleAnswer = json['singleAnswer'];
    options = json['options'].cast<String>();
    answer = json['answer'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['title'] = this.title;
    data['singleAnswer'] = this.singleAnswer;
    data['options'] = this.options;
    data['answer'] = this.answer;
    return data;
  }

  Question copyWith({
    String? type,
    String? title,
    String? singleAnswer,
    List<String>? options,
    List<String>? answer,
  }) {
    return Question(
      type: type ?? this.type,
      title: title ?? this.title,
      options: options ?? this.options,
      answer: answer ?? this.answer,
      singleAnswer: singleAnswer ?? this.singleAnswer
    );
  }
}