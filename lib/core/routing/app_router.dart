import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/features/onbording/ui/onbording_screen.dart';
import 'package:e_chat_app/features/splash/ui/splash_done_screen.dart';
import 'package:flutter/material.dart';


class AppRouter { 
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashDone:
        return MaterialPageRoute(builder: (_) => const SplashDoneScreen());
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}