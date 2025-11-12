import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingStepDetails extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;

  const OnboardingStepDetails({
    super.key,
    required PageController pageController,
    required this.imagePath,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 120.h),
          Image.asset(
            imagePath,
            height: 140,
            width: 289,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(
            height: 83.h,
          ),
          Text(title, style: textTheme.font26Bold , textAlign: TextAlign.center,),
          SizedBox(
            height: 10.h,
          ),
          Text(subTitle, style: textTheme.font18Regular, textAlign: TextAlign.center,),
        ],
      );
  }
}