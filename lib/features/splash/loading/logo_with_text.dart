import 'package:e_chat_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LogoWithText extends StatelessWidget {
 
  const LogoWithText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svgs/logo.svg',
          height: 70.h,
          width: 81.w,
        ),
        SizedBox(
          width: 19.5,
        ),
        const Text(
          "E-Chat",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue
              ),
        )
      ],
    );
  }
}