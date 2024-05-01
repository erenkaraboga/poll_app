import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:poll_app/CreatePollPage.dart';


void main() {

  runApp(GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anket Uygulaması',
      theme: ThemeData(
        fontFamily: "Mali",
        primarySwatch: Colors.blue,
      ),
      home: CreatePollPage(),
    );
  }
}
