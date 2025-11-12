import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/styles.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    primaryColor: AppColors.blue500,
    scaffoldBackgroundColor: AppColors.white,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle:
            WidgetStatePropertyAll(TextStyle(color: AppColors.lightBlue600)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.lightBlue50),
        textStyle:
            WidgetStatePropertyAll(TextStyle(color: AppColors.lightBlue600)),
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.blue500,
      onPrimary: AppColors.white,
      secondary: AppColors.lightBlue200,
      onSecondary: AppColors.lightBlue900,
      error: Colors.red,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.black,
    ),
    extensions: [appTextThemeValue.withColor(AppColors.blue500)]);
