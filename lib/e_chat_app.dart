import 'package:e_chat_app/core/routing/app_router.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/core/theme/dark_theme.dart';
import 'package:e_chat_app/core/theme/light_theme.dart';
import 'package:e_chat_app/features/splash/ui/splash_done_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EChatApp extends StatelessWidget{
  final AppRouter appRouter;
  const EChatApp({super.key ,required this.appRouter});


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // Add design size based on your Figma/design specs
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: const SplashDoneScreen(),
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }

}