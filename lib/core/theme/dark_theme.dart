import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/styles.dart';
import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    primaryColor: AppColors.lightBlue500,
    scaffoldBackgroundColor: AppColors.black,
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      textStyle: WidgetStatePropertyAll(
        TextStyle(color: AppColors.lightBlue600),
      ),
    )),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.lightBlue50),
        textStyle:
            WidgetStatePropertyAll(TextStyle(color: AppColors.lightBlue600)),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.lightBlue500,
      onPrimary: AppColors.black,
      secondary: AppColors.lightBlue200,
      onSecondary: AppColors.lightBlue900,
      error: const Color.fromARGB(255, 198, 40, 40),
      onError: AppColors.black,
      surface: AppColors.white,
      onSurface: AppColors.black,
    ),
    extensions: [appTextThemeValue.withColor(AppColors.lightBlue500)]);
