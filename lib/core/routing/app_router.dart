import 'package:e_chat_app/core/di/injection_container.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/features/auth/register/logic/register_user_information_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_phone_step/auth_phone_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/widgets/otp_input/logic/otp_input_cubit.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/country_code_cubit.dart';
import 'package:e_chat_app/features/auth/ui/auth_screen.dart';
import 'package:e_chat_app/features/onbording/ui/logic/onboarding_cubit.dart';
import 'package:e_chat_app/features/onbording/ui/onbording_screen.dart';
import 'package:e_chat_app/features/splash/logic/splash_done_cubit.dart';
import 'package:e_chat_app/features/splash/ui/splash_done_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashDone:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => getIt<SplashDoneCubit>(),
              child: const SplashDoneScreen()),
        );
      case Routes.onBoarding:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<OnboardingCubit>(),
            child: const OnBoardingScreen(),
          ),
        );
      case Routes.auth:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<CountryCodeCubit>()),
              BlocProvider(create: (_) => getIt<AuthPhoneStepCubit>()),
              BlocProvider(create: (_) => getIt<AuthOTPStepCubit>()),
              BlocProvider(create: (_) => getIt<OTPInputCubit>()),
              BlocProvider(
                create: (_) => getIt<RegisterUserInformationCubit>(),
              ),
            ],
            child: const AuthScreen(),
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
