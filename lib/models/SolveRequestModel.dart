import 'TextQuestionModel.dart';

class SolveRequestModel {

  List<Question>? questions;

  SolveRequestModel({ this.questions});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.questions != null) {
      data['answers'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

