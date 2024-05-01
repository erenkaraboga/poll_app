import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/TextQuestionModel.dart';
import '../poll_controller.dart';

class RadioButtonList extends StatefulWidget {
  final Question question;
  final int index;

  const RadioButtonList({Key? key, required this.question, required this.index}) : super(key: key);

  @override
  _RadioButtonListState createState() => _RadioButtonListState();
}

class _RadioButtonListState extends State<RadioButtonList> {
  var titleController = TextEditingController();
  List<String> items = [];
  String? selectedOption;
  List<String> lastOptions = [];

  @override
  void initState() {
    titleController.text = widget.question.title ?? "";
    lastOptions = List.from(widget.question.options ?? []);
    super.initState();
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
                children: [
                  TextField(
                    controller: titleController,
                    onChanged: (String value) {
                      var updated = widget.question.copyWith(title: titleController.text, options: lastOptions);
                      c.updateTextQuestion(updated, widget.index);
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter question title',
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items.asMap().entries.map((entry) {
                      int index = entry.key;
                      String item = entry.value;
                      return Row(
                        children: [
                          Text(item),
                          Spacer(),
                          Radio<String>(
                            value: item,
                            groupValue: selectedOption,
                            onChanged: null, // Pasif hale getirildi
                          ),

                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                items.removeAt(index);
                                lastOptions.removeAt(index); // Öğenin kendi lastOptions listesinden de sil
                                var updated = widget.question.copyWith(title: titleController.text, options: lastOptions);
                                c.updateTextQuestion(updated, widget.index);
                              });
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: _addRadioButton,
                      child: Text('Add Radio Button'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addRadioButton() {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Radio Button"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Button Name'),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                String itemName = _controller.text.trim();
                if (itemName.isNotEmpty) {
                  setState(() {
                    items.add(itemName);
                    lastOptions.add(itemName); // Öğenin kendi lastOptions listesine de ekle
                    var updated = widget.question.copyWith(title: titleController.text, options: lastOptions);
                    c.updateTextQuestion(updated, widget.index);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
