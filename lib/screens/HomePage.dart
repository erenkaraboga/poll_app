
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:poll_app/controllers/homeController.dart';
import 'package:poll_app/controllers/poll_controller.dart';
import 'package:poll_app/utils/slugify.dart';

import '../models/PollResponseModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  final PollController c = Get.put(PollController());
  final HomeController cHome = Get.put(HomeController());
  TextEditingController pollIdController = TextEditingController();
  @override
  void initState() {
    cHome.saveVisitor();

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: cHome.getImageUrls(), builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Lottie.asset(
                    "assets/lottie/lottie2.json", frameRate: FrameRate.max)
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Text("Pollify",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 150),),
                SizedBox(
                  height: 60,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 50.0,
                      fontFamily: 'Mali',
                      fontWeight: FontWeight.bold,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        FadeAnimatedText('Create Poll'),
                        FadeAnimatedText('Share Your Poll'),
                        FadeAnimatedText('Solve Poll'),
                        FadeAnimatedText('Get your polls answers'),
                        FadeAnimatedText('%100 Anonymous'),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ),
        
                SizedBox(height: 60,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed("/createPoll");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black, borderRadius: BorderRadius
                            .circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("Create Poll", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.white),),
                        ),),
                    ),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () {
                        showDialog();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),

                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("Take Answers", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.black),),
                        ),),
                    ),
                  ],),
                SizedBox(height: 50,),


                SizedBox(height: 200,),
                Text("Images of Active Polls",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                SizedBox(height: 10,),
                Container(
                  width: 600,
                  child: CarouselSlider(
                    options: CarouselOptions(height: 200,autoPlay: true,),
                    items: cHome.images.value.reversed.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                              ),
                              child: Image.network(i));

                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 50,),
                GestureDetector(
                    onTap: (){
                      Get.defaultDialog(content: Image.asset("assets/images/sitemap.png",),title: "");
                    },
                    child: Text("Site Map",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                SizedBox(height: 50,),
              ],
            );
          }
        }),
      ),

    );
  }


  void showDialog() {
    Get.defaultDialog(
        barrierDismissible: true,
        title: "Write your poll id ! ", content: Obx(() {
      return Column(
        children: [
          SizedBox(height: 5,),
          TextField(
            controller: pollIdController,
            onChanged: (String value) {

            },),

          SizedBox(height: 5,),
          SizedBox(height: 5,),
          ElevatedButton(onPressed: () async {
            c.getPollByIdForGetAnswer(pollIdController.text);
          },
            child: Text("Get Answers"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),),

          c.pollResponseModelForGetAnswer.value.sId != null
              ? SingleChildScrollView(
            child: Container(
              width: 400,
              height: 200,
              child: ListView.builder(shrinkWrap: true,
                  itemCount: c.pollResponseModelForGetAnswer.value.userAnswers
                      ?.length,
                  itemBuilder: (context, index) {
                    var selectedPoll = c.pollResponseModelForGetAnswer.value
                        .userAnswers?[index];
                    return ListTile(trailing: IconButton(icon: Icon(
                      Icons.remove_red_eye,), onPressed: () {
                      List<Answers>? list = selectedPoll?.answers ?? [];
                      var name = slugify(selectedPoll?.answers?[0].title ??"");
                      var url = "/getAnswers/${name}";
                      print(url);
                      Get.toNamed(url,arguments:list);
                    },),
                      title: Text("Answer"),
                   );
                  }),
            ),
          )
              : SizedBox(),
        ],
      );
    }));
  }
}
