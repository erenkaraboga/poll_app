import 'dart:convert';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:poll_app/models/ImageResponseModel.dart';
import 'package:poll_app/models/TextQuestionModel.dart';

import '../core/constants.dart';
import '../models/PollResponseModel.dart';
import '../models/SolveRequestModel.dart';

class HomeController extends GetxController {
  var images = <String>[].obs;

  var visitorsCount = 0.obs;
  Future<void> getImageUrls() async {
    var url = "${AppConstants.BASEURL}/api/polls/image-urls";
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var model = ImageResponseModel.fromJson(json.decode(response.body));
      images.value = model.imageUrls ?? [];
      print(response.body);
    } else {
      print('Failed to send question: ${response.reasonPhrase}');
    }
  }

  Future<void> saveVisitor() async {
    var url = "${AppConstants.BASEURL}/api/saveVisitor";
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var jsonModel = json.decode(response.body);
      visitorsCount.value = jsonModel["count"];

    } else {
      print('Failed to send question: ${response.reasonPhrase}');
    }
  }

}
