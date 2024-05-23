import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poll_app/core/constants.dart';
import 'package:poll_app/models/AuthResponseModel.dart';
import 'package:poll_app/models/PollResponseModel.dart';
import 'package:poll_app/models/TextQuestionModel.dart';
import 'package:http/http.dart' as http;

class AdminController extends GetxController {
  var pollResponseModel = PollsResponseModel().obs;
  var authResponseModel = AuthResponseModel().obs;
  var questionList = <Question>[].obs;
  final selectedValue = Rxn<String?>();
  var isValidCreatePoll = false.obs;
  var visitorsCount = 0.0.obs;
  final box = GetStorage();
  var userName = "".obs;
  var password = "".obs;

  var userNameRegister = "".obs;
  var passwordRegister = "".obs;
  var repasswordRegister = "".obs;

  var userNameForgot = "".obs;
  var passwordForgot = "".obs;
  var recoveryForgot = "".obs;

  var isFormValidForgot = false.obs;
  var isWantForgot = false.obs;

  var rememberMe = false.obs;

  var isFormValid = false.obs;

  var isFormValidRegister = false.obs;
  var isLoading = false.obs;
  var isLogined = false.obs;
  var isWantRegister = false.obs;
  var pollCount = 0.0.obs;
  var answeredUserCount = 0.0.obs;
  var pollsFiltered = <Polls>[].obs;
  var search = "".obs;

  checkForm() {
    isFormValid.value = userName.isNotEmpty && password.isNotEmpty;
  }

  checkFormForRegister() {
    print(userNameRegister.value);
    print(passwordRegister.value);
    print(repasswordRegister.value);

    isFormValidRegister.value = userNameRegister.isNotEmpty &&
        passwordRegister.value.isNotEmpty &&
        repasswordRegister.value.isNotEmpty &&
        (passwordRegister.value == repasswordRegister.value);
    print(isFormValidRegister.value);
  }
  checkFormForgot() {

    isFormValidForgot.value = userNameForgot.isNotEmpty &&
        passwordForgot.value.isNotEmpty &&
        recoveryForgot.value.isNotEmpty;

  }

  Future<bool> login() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    final Map<String, String> credentials = {
      'userName': userName.value,
      'password': password.value,
    };

    var url = "${AppConstants.BASEURL}/api/adminLogin";

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

      var json2 = json.decode(response.body);
      print("*****");
      print(json2);

      var model = AuthResponseModel.fromJson(json.decode(response.body));
      authResponseModel.value = model;

      if(rememberMe.value){
        box.write("userName", authResponseModel.value.admin?.userName ?? "");
        box.write("id", authResponseModel.value.admin?.id ?? "");
      }
      isLogined.value = true;

      return true;
    } else {
      showSnackBar(response);

      isLoading.value = false;
      isLogined.value = false;
      box.write("isLogined", false);
      box.write("userName","");
      box.write("id", "");
      print('Failed to send Login: ${response.reasonPhrase}');
      return false;
    }
  }

  checkLogin() {
    if (box.read("userName") != null) {
      if (box.read("userName") !="") {
        isLogined.value = true;
        authResponseModel.value = AuthResponseModel(admin: Admin(userName: box.read("userName"),id: box.read("id")));
      } else {
        isLogined.value = false;
      }
    } else {
      isLogined.value = false;
    }
  }
  disconnect() {
    isLogined.value = false;
    box.write("isLogined", false);
    box.write("userName","");
    box.write("id", "");
    rememberMe.value = false;
    authResponseModel.value = AuthResponseModel();
  }

  Future<String> register() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    final Map<String, String> credentials = {
      'userName': userNameRegister.value,
      'password': passwordRegister.value,
    };

    var url = "${AppConstants.BASEURL}/api/adminRegister";

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(credentials),
    );
    if (response.statusCode == 201) {
      showSnackBar(response);
      print('register Success');
      isLoading.value = false;

      var json2 = json.decode(response.body);
      print(json2);

      var model = AuthResponseModel.fromJson(json.decode(response.body));


      return model.admin?.recoveryKey ?? "";
    } else {
      isLoading.value = false;
      showSnackBar(response);

      return "";
    }
  }
  Future<bool> resetPassword() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    final Map<String, String> credentials = {
      'userName': userNameForgot.value,
      'newPassword': passwordForgot.value,
      'recoveryKey': recoveryForgot.value,
    };

    var url = "${AppConstants.BASEURL}/api/reset-password";

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(credentials),
    );
    if (response.statusCode == 200) {
      showSnackBar(response);
      print('resetPass Success');
      isLoading.value = false;
      isWantForgot.value = false;
      isWantRegister.value = false;
      return true;
    } else {
      isLoading.value = false;
      showSnackBar(response);
      return false;
    }
  }
  refreshInputs(){

  }

  Future<void> getAllPolls() async {
    var url = "${AppConstants.BASEURL}/api/polls";
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
      pollsFiltered.value = pollResponseModel.value.polls ?? [];
      pollCount.value = pollResponseModel.value.polls?.length.toDouble() ?? 0.0;
      getAnsweredUserCount();
    } else {
      print('Failed to send question: ${response.reasonPhrase}');
    }
  }

  Future<String> deletePoll(String pollId) async {
    var url = "${AppConstants.BASEURL}/api/poll/$pollId";
    var response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      print('Question delete successfully');
      await getAllPolls();
      return response.body;
    } else {
      print('Failed to send question: ${response.reasonPhrase}');
      return "";
    }
  }

  Future<void> getVisitors() async {
    var url = "${AppConstants.BASEURL}/api/getVisitor";
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var jsonModel = json.decode(response.body);
      visitorsCount.value = jsonModel["count"].toDouble() ?? 0.0;
      print(jsonModel["count"]);
      print(response.body.toString());
    } else {
      print('Failed to send question: ${response.reasonPhrase}');
    }
  }

  getAnsweredUserCount() {
    var x = pollResponseModel.value.polls;
    var value = 0.0;
    x?.forEach((element) {
      value += element.userAnswers?.length.toDouble() ?? 0.0;
    });
    answeredUserCount.value = value;
  }

  showSnackBar(http.Response response) {
    var json = jsonDecode(response.body);
    var message = json["message"];
    Get.showSnackbar(
      GetSnackBar(
        title: response.statusCode == 200 || response.statusCode == 201 ? "Başarılı" : "Başarısız",
        message: message,
        icon: const Icon(Icons.add),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
