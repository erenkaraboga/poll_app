import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poll_app/controllers/admin_controller.dart';

import 'package:poll_app/ui_components/getAnswers/checkbox.dart';
import 'package:poll_app/ui_components/getAnswers/radio.dart';
import 'package:poll_app/ui_components/getAnswers/text.dart';

import '../models/PollResponseModel.dart';


class GetAnswersPage extends StatefulWidget {
  const GetAnswersPage({Key? key}) : super(key: key);

  @override
  State<GetAnswersPage> createState() => _GetAnswersPageState();
}

class _GetAnswersPageState extends State<GetAnswersPage> {
  List<Answers> list = [];
  String id = "";

  @override
  void initState() {
    list = Get.arguments;
    super.initState();
  }
  final AdminController c = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Solve Pool",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.black),
      body:
         Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                   Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(30)),
                      child: list.isNotEmpty
                          ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: getBody(index)),

                                  ]);
                            }),
                      )
                          : SizedBox(),

                  )
                ],
              ),
            ),
  )

    );}

  Widget getBody(int index) {
    var model =list[index];
    if (model.type == "TEXT") {
      return TextInputItemGetAnswer(
        question: model,
        index: index,
      );
    } else if (model.type == "CHECKBOX") {
      return CheckboxListGetAnswer(
        question: model,
        index: index,
      );
    } else if (model.type == "RADIO") {
      return RadioButtonListGetAnswer(
        question: model,
        index: index,
      );
    } else {

      return SizedBox();
    }
  }
  }






