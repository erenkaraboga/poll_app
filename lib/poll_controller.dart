import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:poll_app/models/TextQuestionModel.dart';
import 'package:poll_app/questions/text.dart';

class PollController extends GetxController {
  final List<String> selectableItems = [
    'Text Input',
    'Single Choice',
    'Multiple Choice',
  ];

  var questionList = <Question>[].obs;
  final selectedValue = Rxn<String?>();
  var isValid = false.obs;

  addQuestion(String type) {
    var model = Question();
    if(type == "TEXT"){
       model = Question(type: "TEXT");
    }
    else if(type == "CHECKBOX"){
      model = Question(type: "CHECKBOX");
    }

    questionList.add(model);
    checkPollForValid();
  }
  updateTextQuestion(Question question,int index) {
    questionList[index] = question;
    checkPollForValid();
    questionList.forEach((element) {
      print(element.title);
      print(element.options.toString());
    });
  }

  checkPollForValid() {
    bool isValidPoll = true;
    for (var element in questionList) {
      if (element.title == null || element.title == "") {
        isValidPoll = false;
        break;
      }
    }

    isValid.value = isValidPoll;
  }

  Future<void> sendQuestion() async {
    var model = QuestionResponseModel(questions: questionList);
    String jsonModel = json.encode(model.toJson());

    var url = "http://192.168.1.104:3000/api/questions";
    print(jsonModel);
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonModel,
    );
    if (response.statusCode == 201) {
      print(response.body.toString());
      showSnackBar(response);
      print('Question sent successfully');
    } else {
      print('Failed to send question: ${response.reasonPhrase}');
    }
  }

  showSnackBar(http.Response response){
    Get.showSnackbar(
      GetSnackBar(
        title: response.body.toString(),
        message: 'Anket Başarıyla Oluşturuldu',
        icon: const Icon(Icons.add),
        duration: const Duration(seconds: 3),
        mainButton: TextButton(
          child: Text('Kopyala'),
          onPressed: () {
            // Implement your action here
          },
        ),
      ),
    );
  }
}
