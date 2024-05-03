import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/TextQuestionModel.dart';
import '../poll_controller.dart';

class RadioButtonListAnswer extends StatefulWidget {
  final Question question;
  final int index;

  const RadioButtonListAnswer({Key? key, required this.question, required this.index}) : super(key: key);

  @override
  _RadioButtonListAnswerState createState() => _RadioButtonListAnswerState();
}

class _RadioButtonListAnswerState extends State<RadioButtonListAnswer> {
  late TextEditingController titleController;
  late List<String> options;
  late String? selectedOption;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.question.title ?? "");
    options = List.from(widget.question.options ?? []);
    selectedOption = options.isNotEmpty ? options[0] : null;
    var updated = widget.question.copyWith(singleAnswer:selectedOption);
    c.answerQuestion(updated,widget.index);
  }
  final PollController c = Get.put(PollController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    readOnly: true,
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter question title',
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: options.asMap().entries.map((entry) {
                      int index = entry.key;
                      String item = entry.value;
                      return Row(
                        children: [
                          Text(item),
                          Spacer(),
                          Radio<String>(
                            value: item,
                            groupValue: selectedOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedOption = value;
                                var updated = widget.question.copyWith(singleAnswer:selectedOption);
                                c.answerQuestion(updated,widget.index);
                              });
                            },
                          ),
                        ],
                      );
                    }).toList(),
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