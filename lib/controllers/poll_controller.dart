import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:poll_app/models/TextQuestionModel.dart';

import '../core/constants.dart';
import '../models/PollResponseModel.dart';
import '../models/SolveRequestModel.dart';

class PollController extends GetxController {
  final List<String> selectableItems = [
    'Text Input',
    'Single Choice',
    'Multiple Choice',
  ];
  final cloudinary =
  Cloudinary.signedConfig(apiKey: "225548188944398",apiSecret: "S0s1UsBPu3luxg5afZX_LyBNv-U",cloudName: "dinqa9wqr");


  var pollResponseModel = QuestionResponseModel().obs;
  var pollResponseModelForGetAnswer = Polls().obs;
  var questionList = <Question>[].obs;
  final selectedValue = Rxn<String?>();
  var isValidCreatePoll = false.obs;

  var image = <int>[].obs;
  var imageUrl = "".obs;

  addQuestion(String type) {
    var model = Question();
    if(type == "TEXT"){
       model = Question(type: "TEXT");
    }
    else if(type == "CHECKBOX"){
      model = Question(type: "CHECKBOX");
    }
    else if(type == "RADIO"){
      model = Question(type: "RADIO");
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
  answerQuestion(Question question,int index) {
    pollResponseModel.value.questions?[index] = question;
    pollResponseModel.value.questions?.forEach((element) {
      print(element.singleAnswer);
      print(element.answer);
    });
  }

  checkPollForValid() {
     var isPoolValid = checkTitle() && checkRadioButtonCount();
    isValidCreatePoll.value = isPoolValid;
  }

 bool checkTitle(){
    bool isTitleValid = true;
    for (var element in questionList) {
      if (element.title == null || element.title == "") {
        isTitleValid = false;
        break;
      }
    }
    return isTitleValid;
  }
  bool checkRadioButtonCount(){
    bool isRadioQuestionValid = true;
    for (var element in questionList) {
      if(element.type == "RADIO" || element.type == "CHECKBOX"){
        if(element.options!.length<=1){
          isRadioQuestionValid = false;
          break;
        }
      }
    }
    return isRadioQuestionValid;
  }


  Future<String> sendQuestion() async {
    var model = QuestionResponseModel(questions: questionList,imageUrl: imageUrl.value);
    String jsonModel = json.encode(model.toJson());

    var url = "${AppConstants.BASEURL}/api/poll";
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
      return response.body;
    } else {

      print('Failed to send question: ${response.reasonPhrase}');
      return "";
    }
  }

  Future<String> sendAnswer(String pollId) async {
    var model = SolveRequestModel(questions: pollResponseModel.value.questions,);
    String jsonModel = json.encode(model.toJson());

    var url = "${AppConstants.BASEURL}/api/poll/$pollId/add-user";
    print(jsonModel);
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonModel,
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      showSnackBarAnswer();
      print('Question sent successfully');
      return response.body;
    } else {

      print('Failed to send question: ${response.reasonPhrase}');
      return "";
    }
  }


  Future<void> getPollById(String id) async {
    await Future.delayed(Duration(seconds: 2));
    var url = "${AppConstants.BASEURL}/api/poll/$id";
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      var model = QuestionResponseModel.fromJson(json.decode(response.body));
      pollResponseModel.value = model;
    } else {
      print('Failed to send question: ${response.reasonPhrase}');
    }
  }
  Future<void> getPollByIdForGetAnswer(String id) async {
    await Future.delayed(Duration(seconds: 2));
    var url = "${AppConstants.BASEURL}/api/poll/$id";
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      var model = Polls.fromJson(json.decode(response.body));
       pollResponseModelForGetAnswer.value = model;
       print(model.sId);
    } else {
      print('Failed to send question: ${response.reasonPhrase}');
    }
  }


  showSnackBar(http.Response response){
    Get.showSnackbar(
      GetSnackBar(
        title: response.body.toString(),
        message: 'İşlem Başarılı',
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
  showSnackBarAnswer(){
    Get.showSnackbar(
      GetSnackBar(
        title: "İşlem Başarılı",
        message: 'Anket Başarıyla Oluşturuldu',
        icon: const Icon(Icons.add),
        duration: const Duration(seconds: 3),

      ),
    );
  }
  Future<CloudinaryResponse?> uploadImage() async {
      if(image.value.isNotEmpty){
        final response = await cloudinary.upload(
            fileBytes: image.value,
            resourceType: CloudinaryResourceType.image,
            folder: "/pool");
        imageUrl.value = response.url ?? "";
        return response;
      }
      else{
        return null;
      }
  }

}
