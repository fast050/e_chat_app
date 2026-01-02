import 'package:e_chat_app/core/di/injection_container.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/core/widgets/phone_input/logic/country_code_cubit.dart';
import 'package:e_chat_app/features/login/logic/login_phone_step/login_phone_step_cubit.dart';
import 'package:e_chat_app/features/login/ui/login_screen.dart';
import 'package:e_chat_app/features/onbording/ui/onbording_screen.dart';
import 'package:e_chat_app/features/splash/ui/splash_done_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashDone:
        return MaterialPageRoute(builder: (_) => const SplashDoneScreen());
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<CountryCodeCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<LoginPhoneStepCubit>(),
              )
            ],
            child: const LoginScreen(),
          ),
        );
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
