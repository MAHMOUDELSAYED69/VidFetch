import 'package:flutter/material.dart';
import 'package:vid_fetch/router/page_transition.dart';
import 'package:vid_fetch/view/screens/home.dart';

import '../utils/constants/routes.dart';
import '../view/screens/splash.dart';

abstract class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteManager.initialRoute:
        return PageTransitionManager.fadeTransition(const SplashScreen());

      case RouteManager.home:
        return PageTransitionManager.fadeTransition(const HomeScreen());
      default:
        return null;
    }
  }
}
