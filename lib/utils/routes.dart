import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:poll_app/screens/AdminLoginPage.dart';
import 'package:poll_app/screens/CreatePollPage.dart';
import 'package:poll_app/screens/PollPreviewPage.dart';
import 'package:poll_app/screens/SolvePollPage.dart';

import '../screens/HomePage.dart';

appRoutes() => [
  GetPage(
    name: '/home',
    page: () => HomePage(),
    middlewares: [RouteMiddleware()],
    transitionDuration: Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/createPoll',
    page: () => CreatePollPage(),
    middlewares: [RouteMiddleware()],
    transitionDuration: Duration(milliseconds: 500),
  ),

  GetPage(
    name: '/solvePool/:id',
    page: () => SolvePollPage(),
    middlewares: [RouteMiddleware()],
    transitionDuration: Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/admin',
    page: () => AdminLoginPage(),
    middlewares: [RouteMiddleware()],
    transitionDuration: Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/preview/:id',
    page: () => PollPreviewPage(),
    middlewares: [RouteMiddleware()],
    transitionDuration: Duration(milliseconds: 500),
  ),
];

class RouteMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    print(page?.name);
    return super.onPageCalled(page);
  }}