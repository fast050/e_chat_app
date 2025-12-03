import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/gradients.dart';
import 'package:e_chat_app/features/login/ui/login_animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StackBackgroundWithShapeLogin extends StatelessWidget {
  final Widget child;

 const StackBackgroundWithShapeLogin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shapeHeight = size.height * .45 + MediaQuery.of(context).padding.top;

    //handle background color for both Theme Mode, Light, Dark
    final mode = MediaQuery.platformBrightnessOf(context);
    final isDarkMode = mode == Brightness.dark;
    final Color bottomShapeColor =
        isDarkMode ? AppColors.neutral900 : AppColors.lightBlue50;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;    

    return Stack(
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: isKeyboardOpen ?  1.0 : 0.0),
          duration: Duration(milliseconds: 600),
          curve: Curves.bounceOut,
          builder: (context, value, _) {
            return CustomPaint(
              painter: LoginBackgroundAnimate(
                shouldAnimate: true,
                topShapeGradient: AppGradients.lightBlueGradient,
                bottomShapeColor: bottomShapeColor,
                offsetBetweenTopBottom: 70.h,
                animatedValue: value,
              ),
              child: SizedBox(
                height: shapeHeight,
                width: double.infinity,
              ),
            );
          },
        ),
       child,
      ],
    );
  }
}
