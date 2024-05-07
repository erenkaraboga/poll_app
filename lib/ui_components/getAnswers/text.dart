

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:poll_app/models/PollResponseModel.dart';

import '../../controllers/poll_controller.dart';
import '../../models/TextQuestionModel.dart';



class TextInputItemGetAnswer extends StatefulWidget {
  const TextInputItemGetAnswer({super.key, required this.question, required this.index,  });
  final Answers question;
  final int index;


  @override
  State<TextInputItemGetAnswer> createState() => _TextInputItemGetAnswerState();
}

class _TextInputItemGetAnswerState extends State<TextInputItemGetAnswer> {
  var titleController = TextEditingController();

  var answerController = TextEditingController();
 @override
  void initState() {
   titleController.text =widget.question.title ?? "";
   answerController.text = widget.question.singleAnswer ?? "";
    super.initState();
  }
   final PollController c = Get.put(PollController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                          hintText: 'Enter question title',
                        ),controller: titleController)
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10,right: 20,bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey,),borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: TextField(
                              onChanged: (String value){},
                              enabled: false,
                              decoration: InputDecoration(border: InputBorder.none,  hintText: 'Enter answer',),
                              controller: answerController,
                              maxLines: null, // Set to null to enable multiline input
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
