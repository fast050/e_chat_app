import 'package:flutter/material.dart';

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme>{
    final TextStyle font26Bold;
    final TextStyle font22Black;
    final TextStyle font18SemiBold;
    final TextStyle font18Regular;
    final TextStyle font16Medium;

    const AppTextTheme({
      required this.font26Bold,
      required this.font22Black,
      required this.font18SemiBold,
      required this.font18Regular,
      required this.font16Medium,
    });

  @override
  ThemeExtension<AppTextTheme> copyWith(
      {TextStyle? font26Bold,
      TextStyle? font22Black,
      TextStyle? font18SemiBold,
      TextStyle? font18Regular,
      TextStyle? font16Medium,
      }
  ) {
    return AppTextTheme(
      font26Bold: font26Bold ?? this.font26Bold,
      font22Black: font22Black ?? this.font22Black,
      font18SemiBold: font18SemiBold ?? this.font18SemiBold,
      font18Regular: font18Regular ?? this.font18Regular,
      font16Medium: font16Medium ?? this.font16Medium
    );
  }



  @override
  ThemeExtension<AppTextTheme> lerp(covariant ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) return this;
    return AppTextTheme(
      font26Bold: TextStyle.lerp(font26Bold, other.font26Bold, t)!,
      font22Black: TextStyle.lerp(font22Black, other.font22Black, t)!,
      font18SemiBold: TextStyle.lerp(font18SemiBold, other.font18SemiBold, t)!,
      font18Regular: TextStyle.lerp(font18Regular, other.font18Regular, t)!,
      font16Medium: TextStyle.lerp(font16Medium, other.font16Medium, t)!,
    );
  }

  AppTextTheme withColor(Color color) {
    return AppTextTheme(
      font26Bold: font26Bold.copyWith(color: color),
      font22Black: font22Black.copyWith(color: color),
      font18SemiBold: font18SemiBold.copyWith(color: color),
      font18Regular: font18Regular.copyWith(color: color),
      font16Medium: font16Medium.copyWith(color: color),
    );
  } 
}
