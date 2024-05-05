import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:poll_app/controllers/poll_controller.dart';
import '../ui_components/answers/checkbox.dart';
import '../ui_components/answers/radio.dart';
import '../ui_components/answers/text.dart';
import '../ui_components/preview/checkbox.dart';
import '../ui_components/preview/radio.dart';
import '../ui_components/preview/text.dart';

class PollPreviewPage extends StatefulWidget {
  const PollPreviewPage({Key? key}) : super(key: key);

  @override
  State<PollPreviewPage> createState() => _PollPreviewPageState();
}

class _PollPreviewPageState extends State<PollPreviewPage> {
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
            "Preview Pool",
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
      return TextInputItemPreview(
        question: model.questions![index],
        index: index,

      );
    } else if (model.questions![index].type == "CHECKBOX") {
      return CheckBoxListPreview(
        question: model.questions![index],
        index: index,
      );
    } else if (model.questions![index].type == "RADIO") {
      return RadioButtonListPreview(
        question: model.questions![index],
        index: index,
      );
    } else {

      return SizedBox();
    }
  }
  }



