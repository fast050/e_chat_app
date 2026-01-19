import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class FilledTextButtonBlue50 extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const FilledTextButtonBlue50(
      {super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
          foregroundColor:
              isDarkMode ?  AppColors.lightBlue500 : AppColors.blue500,
          backgroundColor: isDarkMode ? AppColors.neutral900 : AppColors.blue50,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 22)),
      child: Text(
        text,
        style: Theme.of(context).extension<AppTextTheme>()!.font18SemiBold,
      ),
    );
  }
}
