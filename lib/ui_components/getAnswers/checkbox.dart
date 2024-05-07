
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:poll_app/models/PollResponseModel.dart';

import '../../controllers/poll_controller.dart';
import '../../models/TextQuestionModel.dart';


class CheckboxListGetAnswer extends StatefulWidget {
  final Answers question;
  final int index;

  const CheckboxListGetAnswer({super.key, required this.question, required this.index});
  @override
  _CheckboxListGetAnswerState createState() => _CheckboxListGetAnswerState();
}

class _CheckboxListGetAnswerState extends State<CheckboxListGetAnswer> {
  var titleController = TextEditingController();
  List<String> lastOptions = [];
  List<bool> checkedValues = [];
  List<String> list  = [];
  @override
  void initState() {
    titleController.text = widget.question.title ?? "";
    lastOptions = List.from(widget.question.options ?? []);


    checkedValues = List.filled(lastOptions.length, false);
    getAnswerForList();
    super.initState();
  }
  getAnswerForList(){
    if(widget.question.options!=null){
      for (String answerOption in widget.question.answer ?? []) {
        int index = lastOptions.indexOf(answerOption);
        if (index != -1) {
          checkedValues[index] = true;
        }
      }
    }

  }

  final PollController c = Get.put(PollController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  TextField(
                    readOnly: true,
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter question title',
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: lastOptions.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    title: Text(lastOptions[index]),
                                    contentPadding: EdgeInsets.zero,
                                    value: checkedValues[index],
                                    onChanged: (newValue) {
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}