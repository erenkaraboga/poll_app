import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/TextQuestionModel.dart';
import '../poll_controller.dart';

class CheckboxList extends StatefulWidget {
  final Question question;
  final int index;

  const CheckboxList({super.key, required this.question, required this.index});
  @override
  _CheckboxListState createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
  var titleController = TextEditingController();
  List<String> items = [];
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
                    controller: titleController,
                    onChanged: (String value) {
                      var updated = widget.question.copyWith(title: titleController.text, options: lastOptions);
                      c.updateTextQuestion(updated, widget.index);
                    },
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
                          itemCount: items.length + 1,
                          itemBuilder: (context, index) {
                            if (index == items.length) {
                              // Son öğe, yani artı butonu
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: ElevatedButton(
                                  onPressed: _addCheckbox,
                                  child: Text('Add Checkbox'),
                                ),
                              );
                            }
                            return Row(
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    title: Text(items[index]),
                                    contentPadding: EdgeInsets.zero,
                                    value: false,
                                    onChanged: (newValue) {},
                                  ),
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

  void _addCheckbox() {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Checkbox"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Checkbox Name'),
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