import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

// Plain TextStyles: the real theme uses GoogleFonts, which tries to download
// fonts at runtime and fails inside tests.
const _testTextTheme = AppTextTheme(
  font12Medium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  font12Bold: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
  font14Regular: TextStyle(fontSize: 14),
  font16Regular: TextStyle(fontSize: 16),
  font16Medium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  font16Bold: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  font18Regular: TextStyle(fontSize: 18),
  font18SemiBold: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  font20Regular: TextStyle(fontSize: 20),
  font20Medium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  font22Black: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
  font24Regular: TextStyle(fontSize: 24),
  font26Bold: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
  font32Medium: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
  font35Bold: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
  font39Bold: TextStyle(fontSize: 39, fontWeight: FontWeight.w700),
  font40Black: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
);

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget child) {
    return pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => MaterialApp(
          theme: ThemeData(
            extensions: const [_testTextTheme, lightSemanticColors],
          ),
          home: Scaffold(body: child),
        ),
      ),
    );
  }
}
