class QuestionResponseModel {
  String? id;
  List<Question>? questions;

  QuestionResponseModel({this.id, this.questions});

  QuestionResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    if (json['questions'] != null) {
      questions = <Question>[];
      json['questions'].forEach((v) {
        questions!.add(new Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Question {
  String? id;
  String? type;
  String? title;
  String? singleAnswer;
  List<String>? options;
  List<String>? answer;

  Question(
      {this.id, this.type, this.title, this.singleAnswer, this.options, this.answer});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    type = json['type'];
    title = json['title'];
    singleAnswer = json['singleAnswer'];
    options = json['options'] != null ? List<String>.from(json['options']) : [];
    answer = json['answer'] != null ? List<String>.from(json['answer']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['singleAnswer'] = this.singleAnswer;
    data['options'] = this.options;
    data['answer'] = this.answer;
    return data;
  }

  Question copyWith({
    String? id,
    String? type,
    String? title,
    String? singleAnswer,
    List<String>? options,
    List<String>? answer,
  }) {
    return Question(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        options: options ?? this.options,
        answer: answer ?? this.answer,
        singleAnswer: singleAnswer ?? this.singleAnswer
    );
  }
}