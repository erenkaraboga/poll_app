import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:poll_app/controllers/poll_controller.dart';
import 'package:flutter/services.dart';
import 'package:poll_app/ui_components/questions/checkbox.dart';
import 'package:poll_app/ui_components/questions/radio.dart';
import 'package:poll_app/ui_components/questions/text.dart';
import 'package:poll_app/utils/slugify.dart';

class CreatePollPage extends StatefulWidget {
  CreatePollPage({super.key});

  @override
  State<CreatePollPage> createState() => _CreatePollPageState();
}

class _CreatePollPageState extends State<CreatePollPage> {
  final PollController c = Get.put(PollController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              showSuccessDialog("41241241241241");
            },
            child: const Text(
              "Create Poll",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              children: [
               c.image.value.isNotEmpty ?  Container(
                    width: 400,
                    height: 400,
                    child: Image.memory(Uint8List.fromList(c.image.value))): SizedBox(),
                SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(30)),
                        child: c.questionList.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: c.questionList.length,
                              itemBuilder: (context, index) {
                                return Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Expanded(child: getBody(index)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            c.questionList.removeAt(index);
                                          },),
                                      )
                                    ]);
                              }),
                        )
                            : SizedBox(),
                      );
                    }),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        dropdown(),
                        ElevatedButton(onPressed: () {
                          getImage(ImageSource.gallery);
                        }, child: Text("Add image")),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(() {
                          return ElevatedButton(
                              onPressed: c.isValidCreatePoll.value ? () async {
                                var pollId = await c.sendQuestion();
                                if (pollId != "") {
                                  print(pollId);
                                  showSuccessDialog(pollId);
                                }
                              } : null, child:
                          Text("Save Poll", style: TextStyle(),)
                          );
                        })
                      ],
                    )
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) {

      return;
    }
    var f = await pickedFile.readAsBytes();
   c.image.value = f;
   var response = await c.uploadImage();
   if(response!=null){
     showSnackBar(response);
   }
  }
  showSnackBar(CloudinaryResponse? response){
    Get.showSnackbar(
      GetSnackBar(
        title:  response?.statusCode == 200 ?"Başarılı" : "Başarısız",
        message: response?.statusCode == 200 ?"Fotoğraf yüklendi" : "Fotoğraf yüklenemedi",
        icon: const Icon(Icons.add),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  getBody(int index) {
    if (c.questionList[index].type == "TEXT") {
      return TextInputItem(
          question: c.questionList[index], index: index);
    }
    else if (c.questionList[index].type == "CHECKBOX") {
      return CheckboxList(question: c.questionList[index], index: index);
    }
    else if (c.questionList[index].type == "RADIO") {
      return RadioButtonList(question: c.questionList[index], index: index);
    }
  }

  void showSuccessDialog(String id) {
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Your Poll is Saved", content: Column(
      children: [
        Text("Here's your sharing id !"),
        SizedBox(height: 5,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(id.toString(), style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(width: 20,),
            ElevatedButton(onPressed: () async {
              var modified = slug(id);
              await Clipboard.setData(ClipboardData(text: modified));
            },
              child: Text("Copy"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),)
          ],),

        SizedBox(height: 5,),
        Text("You can share your survey with your friends below."),

        Row(
          children: [
            Text("http://localhost:56227/solvePool/${slug(id)}"),
            SizedBox(width: 20,),
            ElevatedButton(onPressed: () async {
              var modified = slug("http://localhost:56227/solvePool/${slug(id)}");
              await Clipboard.setData(ClipboardData(text: modified));
            },
              child: Text("Copy"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),)
          ],
        ),
        SizedBox(height: 5,),
        ElevatedButton(onPressed: () async {
          Get.offAllNamed("/home");
        },
          child: Text("Return Home"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),),
      ],
    ));
  }

  dropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Expanded(
              child: Text(
                'Select Question Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: c.selectableItems
            .map((String item) =>
            DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ))
            .toList(),
        value: c.selectedValue.value,
        onChanged: (value) {
          if (value == "Text Input") {
            c.addQuestion("TEXT");
          }
          else if (value == "Multiple Choice") {
            c.addQuestion("CHECKBOX");
          }
          else if (value == "Single Choice") {
            c.addQuestion("RADIO");
          }
          c.selectedValue.value = value;
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.black,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.black,
          ),
          offset: const Offset(-20, -10),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
