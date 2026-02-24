import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/theme/styles.dart';
import 'package:flutter/material.dart';

/// DARK THEME
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.lightBlue500,
  scaffoldBackgroundColor: AppColors.black,
  colorScheme: ColorScheme.dark(
    primary: AppColors.lightBlue500,
    onPrimary: AppColors.black,
    secondary: AppColors.neutral900,
    onSecondary: AppColors.lightBlue900,
    surface: AppColors.black,
    onSurface: AppColors.neutral100,
    error: AppColors.red500,
    onError: AppColors.black,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.white,
    contentTextStyle: appTextThemeValue.font16Medium.copyWith(
      color: AppColors.black
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
  extensions: <ThemeExtension<dynamic>>[
    appTextThemeValue.withColor(AppColors.lightBlue500),
    AppSemanticColors(
      // 5 text roles from table
      textPrimary: AppColors.neutral50,
      textSecondary: AppColors.neutral300,
      textAccent: AppColors.neutral100,
      textOnPrimary: AppColors.lightBlue500,
      textOnSecondry: AppColors.white,
      textPrimaryBrand: AppColors.lightBlue500,
      inputBackground: AppColors.neutral900,
      cardBackground: AppColors.neutral100, 
      error: AppColors.red500,
    ),
  ],
);
