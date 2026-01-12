import 'package:flutter/material.dart';

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  final TextStyle font16Medium;
  final TextStyle font16Bold;
  final TextStyle font18Regular;
  final TextStyle font18SemiBold;
  final TextStyle font20Regular;
  final TextStyle font20Medium;
  final TextStyle font22Black;
  final TextStyle font24Regular;
  final TextStyle font26Bold;
  final TextStyle font32Medium;
  final TextStyle font35Bold;
  final TextStyle font39Bold;
  final TextStyle font40Black;

  const AppTextTheme({
    required this.font16Bold,
    required this.font16Medium,
    required this.font18SemiBold,
    required this.font18Regular,
    required this.font20Regular,
    required this.font20Medium,
    required this.font22Black,
    required this.font24Regular,
    required this.font26Bold,
    required this.font32Medium,
    required this.font35Bold,
    required this.font39Bold,
    required this.font40Black,
  });

  @override
  ThemeExtension<AppTextTheme> copyWith({
    TextStyle? font16Bold,
    TextStyle? font16Medium,
    TextStyle? font18SemiBold,
    TextStyle? font18Regular,
    TextStyle? font20Regular,
    TextStyle? font20Medium,
    TextStyle? font22Black,
    TextStyle? font24Regular,
    TextStyle? font26Bold,
    TextStyle? font32Medium,
    TextStyle? font35Bold,
    TextStyle? font39Bold,
    TextStyle? font40Black,
  }) {
    return AppTextTheme(
      font16Bold: font16Bold ?? this.font16Bold,
      font16Medium: font16Medium ?? this.font16Medium,
      font18SemiBold: font18SemiBold ?? this.font18SemiBold,
      font18Regular: font18Regular ?? this.font18Regular,
      font20Regular: font20Regular ?? this.font20Regular,
      font20Medium: font20Medium ?? this.font20Medium,
      font22Black: font22Black ?? this.font22Black,
      font24Regular: font24Regular ?? this.font24Regular,
      font26Bold: font26Bold ?? this.font26Bold,
      font32Medium: font32Medium ?? this.font32Medium,
      font35Bold: font35Bold ?? this.font35Bold,
      font39Bold: font39Bold ?? this.font39Bold,
      font40Black: font40Black ?? this.font40Black,
    );
  }

  @override
  ThemeExtension<AppTextTheme> lerp(
      covariant ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) return this;
    return AppTextTheme(
      font16Medium: TextStyle.lerp(font16Medium, other.font16Medium, t)!,
      font16Bold: TextStyle.lerp(font16Bold, other.font16Bold, t)!,
      font18Regular: TextStyle.lerp(font18Regular, other.font18Regular, t)!,
      font18SemiBold: TextStyle.lerp(font18SemiBold, other.font18SemiBold, t)!,
      font20Regular: TextStyle.lerp(font20Regular, other.font20Regular, t)!,
      font20Medium: TextStyle.lerp(font20Medium, other.font20Medium, t)!,
      font22Black: TextStyle.lerp(font22Black, other.font22Black, t)!,
      font24Regular: TextStyle.lerp(font24Regular, other.font24Regular, t)!,
      font26Bold: TextStyle.lerp(font26Bold, other.font26Bold, t)!,
      font32Medium: TextStyle.lerp(font32Medium, other.font32Medium, t)!,
      font35Bold: TextStyle.lerp(font35Bold, other.font35Bold, t)!,
      font39Bold: TextStyle.lerp(font39Bold, other.font39Bold, t)!,
      font40Black: TextStyle.lerp(font40Black, other.font40Black, t)!,
    );
  }

  AppTextTheme withColor(Color color) {
    return AppTextTheme(
      font16Medium: font16Medium.copyWith(color: color),
      font16Bold: font16Bold.copyWith(color: color),
      font18SemiBold: font18SemiBold.copyWith(color: color),
      font18Regular: font18Regular.copyWith(color: color),
      font20Regular: font20Regular.copyWith(color: color),
      font20Medium: font20Medium.copyWith(color: color),
      font22Black: font22Black.copyWith(color: color),
      font24Regular: font24Regular.copyWith(color: color),
      font26Bold: font26Bold.copyWith(color: color),
      font32Medium: font32Medium.copyWith(color: color),
      font35Bold: font35Bold.copyWith(color: color),
      font39Bold: font39Bold.copyWith(color: color),
      font40Black: font40Black.copyWith(color: color),
    );
  }
}
