import 'package:flutter/material.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/theme/styles.dart';

/// LIGHT THEME
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.blue500,
  scaffoldBackgroundColor: AppColors.white,
  colorScheme: ColorScheme.light(
    primary: AppColors.blue500,
    onPrimary: AppColors.white,
    secondary: AppColors.lightBlue50,
    onSecondary: AppColors.lightBlue900,
    surface: AppColors.white,
    onSurface: AppColors.neutral900,
    error: Colors.red,
    onError: AppColors.white,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.black,
    contentTextStyle: appTextThemeValue.font16Medium.copyWith(
      color: AppColors.blue100
    )
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.lightBlue600),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.lightBlue50),
      foregroundColor: WidgetStatePropertyAll(AppColors.lightBlue600),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    
  ),
  extensions: <ThemeExtension<dynamic>>[
    appTextThemeValue.withColor(AppColors.blue500),
    AppSemanticColors(
      // 5 text roles from table
      textPrimary: AppColors.neutral900,
      textSecondary: AppColors.neutral300,
      textAccent: AppColors.lightBlue900,
      textOnPrimary: AppColors.white,
      textOnSecondry: AppColors.lightBlue600,
      textPrimaryBrand: AppColors.blue500,
      error: AppColors.red500,
      inputBackground: AppColors.neutral50,
      cardBackground: AppColors.neutral100,
    ),
  ],
);
