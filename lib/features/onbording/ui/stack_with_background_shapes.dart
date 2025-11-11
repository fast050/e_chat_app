import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/features/onbording/ui/onborading_step_background_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class StackWithBackgroundShapes extends StatelessWidget {
  final Widget child;

  const StackWithBackgroundShapes({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shiftValue = size.height * .60;
    final firstShapeDownShift = shiftValue - 70.h;
    final secondShapeDownShift = shiftValue;
    
    //handle background color for both Theme Mode, Light, Dark
    final mode = MediaQuery.platformBrightnessOf(context);
    final isDarkMode = mode == Brightness.dark;     
        final Color firstShapeColor =
        isDarkMode ? AppColors.neutral900 : AppColors.lightBlue50;
        final Color secondShapeColor =
        isDarkMode ? AppColors.blue900 : AppColors.blue100;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          top: firstShapeDownShift,
          child: ClipPath(
            clipper: OnBoardingBackgroundClipper(),
            child: Container(
              color: firstShapeColor,
            ),
          ),
        ),
        Positioned.fill(
          top: secondShapeDownShift,
          child: ClipPath(
            clipper: OnBoardingBackgroundClipper(),
            child: Container(
              color: secondShapeColor,
            ),
          ),
        ),
        child,
      ],
    );
  }
}