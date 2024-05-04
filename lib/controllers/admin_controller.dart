
import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poll_app/models/PollResponseModel.dart';
import 'package:poll_app/models/TextQuestionModel.dart';
import 'package:http/http.dart' as http;


class AdminController extends GetxController {

  var pollResponseModel = PollsResponseModel().obs;
  var questionList = <Question>[].obs;
  final selectedValue = Rxn<String?>();
  var isValidCreatePoll = false.obs;
  var visitorsCount = 0.obs;
  final box = GetStorage();
  var userName = "".obs;
  var password = "".obs;
  var isFormValid = false.obs;
  var isLoading = false.obs;
  var isLogined = false.obs;
  var pollCount = 0.0.obs;

   checkForm(){
     isFormValid.value = userName.isNotEmpty && password.isNotEmpty;
  }


  Future<bool> login() async {
    isLoading.value = true;
   await  Future.delayed(Duration(seconds: 2));
    final Map<String, String> credentials = {
      'userName': userName.value,
      'password': password.value,
    };


    var url = "http://192.168.1.104:3000/api/adminLogin";

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(credentials),
    );
    if (response.statusCode == 200) {
      showSnackBar(response);
      print('Login Success');
      isLoading.value = false;
      isLogined.value = true;
      box.write("isLogined", true);
      return true;
    } else {
      showSnackBar(response);

      isLoading.value = false;
      isLogined.value = false;
      box.write("isLogined", false);
      print('Failed to send Login: ${response.reasonPhrase}');
      return false;
    }
  }

   checkLogin(){
    if(box.read("isLogined") !=null){
      if(box.read("isLogined")){
        isLogined.value=true;
      }
      else {
        isLogined.value=false;
      }
    }
    else{
      isLogined.value=false;
    }
  }
  Future<void> getAllPolls() async {
    var url = "http://192.168.1.104:3000/api/polls";
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      var json2 = json.decode(response.body);
      print("*****");
      print(json2);

      var model = PollsResponseModel.fromJson(json.decode(response.body));
       pollResponseModel.value = model;
      pollCount.value = pollResponseModel.value.polls?.length.toDouble() ??0.0;
    } else {
      print('Failed to send question: ${response.reasonPhrase}');
    }
  }

  showSnackBar(http.Response response){
     var json = jsonDecode(response.body);
      var message = json["message"];
    Get.showSnackbar(
      GetSnackBar(
        title:  response.statusCode == 200 ?"Başarılı" : "Başarısız",
        message: message,
        icon: const Icon(Icons.add),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
