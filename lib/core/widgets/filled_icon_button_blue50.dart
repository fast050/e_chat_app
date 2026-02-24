import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilledIconButtonBlue50 extends StatelessWidget {
  final void Function() onPressed;
  final Icon icon;
  final String text;

  const FilledIconButtonBlue50(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
          foregroundColor:
              isDarkMode ? AppColors.lightBlue500 : AppColors.blue500,
          backgroundColor: isDarkMode ? AppColors.neutral900 : AppColors.blue50,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 22)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon,
          SizedBox(width: 18.w),
          Text(
            text,
            style: Theme.of(context).extension<AppTextTheme>()!.font18SemiBold,
          )
        ],
      ),
    );
  }
}
