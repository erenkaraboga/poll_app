import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:poll_app/controllers/poll_controller.dart';
import 'package:poll_app/ui_components/answers/checkbox.dart';
import 'package:poll_app/ui_components/answers/radio.dart';
import 'package:poll_app/ui_components/answers/text.dart';


class SolvePollPage extends StatefulWidget {
  const SolvePollPage({Key? key}) : super(key: key);

  @override
  State<SolvePollPage> createState() => _SolvePollPageState();
}

class _SolvePollPageState extends State<SolvePollPage> {
  String id = "";

  @override
  void initState() {
    super.initState();
    var data = Get.parameters;
    String idFromPath = data['id'] ?? "";
    id = idFromPath;
  }
  final PollController c = Get.put(PollController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Solve Pool",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.black),
      body: FutureBuilder(future: c.getPollById(id),builder: (context , snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset("assets/lottie/lottie2.json",frameRate: FrameRate.max)
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return  Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Row(
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
                      child: c.pollResponseModel.value.questions!.isNotEmpty
                          ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: c.pollResponseModel.value.questions?.length,
                            itemBuilder: (context, index) {
                              return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: getBody(index)),

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
                      SizedBox(
                        height: 10,
                      ),

                         ElevatedButton(onPressed:  () async {
                          await c.sendAnswer(c.pollResponseModel.value.id ?? "");

                        } , child:
                        Text("Save Poll", style: TextStyle(),)
                        ),

                    ],
                  )
                ],
              ),
            ),
          );

      }
      }),
    );
  }

  Widget getBody(int index) {
    var model = c.pollResponseModel.value;
    if (model.questions![index].type == "TEXT") {
      return TextInputItemAnswer(
        question: model.questions![index],
        index: index,
        isCreated: false,
      );
    } else if (model.questions![index].type == "CHECKBOX") {
      return CheckboxListAnswer(
        question: model.questions![index],
        index: index,
      );
    } else if (model.questions![index].type == "RADIO") {
      return RadioButtonListAnswer(
        question: model.questions![index],
        index: index,
      );
    } else {

      return SizedBox();
    }
  }

}


