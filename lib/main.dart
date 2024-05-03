import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:poll_app/CreatePollPage.dart';
import 'package:poll_app/utils/routes.dart';
import 'package:url_strategy/url_strategy.dart';

import 'HomePage.dart';


void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Anket Uygulaması',
      theme: ThemeData(
        fontFamily: "Mali",
        primarySwatch: Colors.blue,
      ),
      getPages:appRoutes(),
      initialRoute: "/home",
    );
  }
}
