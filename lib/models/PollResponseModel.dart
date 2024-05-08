class PollsResponseModel {
  List<Polls>? polls;
  PollsResponseModel({this.polls});

  PollsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['polls'] != null) {
      polls = <Polls>[];
      json['polls'].forEach((v) {
        polls!.add(new Polls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.polls != null) {
      data['polls'] = this.polls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Polls {
  String? sId;
  String? imageUrl;
  List<Questions>? questions;
  String? createdAt;
  List<UserAnswers>? userAnswers;


  Polls({this.sId, this.questions, this.userAnswers,});

  Polls.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    imageUrl = json['imageUrl'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
    if (json['userAnswers'] != null) {
      userAnswers = <UserAnswers>[];
      createdAt = json['createdAt'];
      json['userAnswers'].forEach((v) {
        userAnswers!.add(new UserAnswers.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['imageUrl'] = this.imageUrl;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    if (this.userAnswers != null) {
      data['userAnswers'] = this.userAnswers!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Questions {
  String? type;
  String? title;
  String? singleAnswer;
  List<String>? options;
  List<String>? answer;


  Questions(
      {this.type,
        this.title,
        this.singleAnswer,
        this.options,
        this.answer,
      });

  Questions.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    singleAnswer = json['singleAnswer'];
    options = json['options'] != null ? List<String>.from(json['options']) : [];
    answer = json['answer'] != null ? List<String>.from(json['answer']) : [];

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
}

class UserAnswers {
  List<Answers>? answers;
  String? sId;

  UserAnswers({this.answers, this.sId});

  UserAnswers.fromJson(Map<String, dynamic> json) {
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    return data;
  }
}

class Answers {
  String? type;
  String? title;
  String? singleAnswer;
  List<String>? options;
  List<String>? answer;


  Answers(
      {this.type,
        this.title,
        this.singleAnswer,
        this.options,
        this.answer,
        });

  Answers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    singleAnswer = json['singleAnswer'];
    options = json['options'] != null ? List<String>.from(json['options']) : [];
    answer = json['answer'] != null ? List<String>.from(json['answer']) : [];
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
}