import 'package:e_chat_app/core/theme/app_text_theme.dart';
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

    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

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
         Text(
          "E-Chat",
          style: textTheme.font40Black.copyWith(
            fontStyle: FontStyle.italic,
            color: AppColors.blue700
          ),
        )
      ],
    );
  }
}