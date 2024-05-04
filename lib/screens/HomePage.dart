import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:poll_app/controllers/poll_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final PollController c = Get.put(PollController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: FutureBuilder(future: c.getVisitors(),builder: (context , snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Lottie.asset("assets/lottie/lottie2.json",frameRate: FrameRate.max)
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return    Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          color: Colors.black, borderRadius: BorderRadius.circular(10)),
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
                      Get.toNamed("/solvePool/6632642dd9e70dc149171d3f");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(10)),

                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Solve Poll", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Colors.black),),
                      ),),
                  ),
                ],),
              SizedBox(height: 20,),
              Obx(() {
                return Text("Visitors Count :${c.visitorsCount.value.toString()}" );
              }),
            ],
          );


      }
      }),

     );
  }
}