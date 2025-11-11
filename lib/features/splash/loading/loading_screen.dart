import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/features/splash/loading/chat_border_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_chat_app/features/splash/loading/logo_with_text.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          context.pushNamed(Routes.onBoarding);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
   
   final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LogoWithText(),
              // move the bubble a bit upwards to sit visually inside the screen
              Transform.translate(
                offset: Offset(0, -24.h),
                child: ChatBorderWithText(),
              ),
              Text(
                "Versions 1.0.0",
                style: textTheme.font18SemiBold,
              )
            ],
          ),
        ),
      ),
    );
  }
}
