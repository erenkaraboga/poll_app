import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poll_app/utils/routes.dart';
import 'package:url_strategy/url_strategy.dart';

import 'screens/HomePage.dart';


Future<void> main() async {
  await GetStorage.init();
  setPathUrlStrategy();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pollify',
      theme: ThemeData(
        fontFamily: "Mali",
        useMaterial3: false
      ),
      getPages:appRoutes(),
      initialRoute: "/home",
    );
  }

}

