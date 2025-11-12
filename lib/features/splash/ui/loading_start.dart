import 'package:e_chat_app/features/splash/ui/show_animated_widget_from_bottom_to_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingStart extends StatelessWidget {
  const LoadingStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: 240.h),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: Opacity(
                  opacity: .3,
                  child: SvgPicture.asset(
                    'assets/svgs/logo.svg',
                    height: 150.h,
                    width: 170.w,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: ShowAnimatedWidgetFromBottomToTop(
                  duration: Duration(seconds: 3),
                  child: SvgPicture.asset(
                    'assets/svgs/logo.svg',
                    height: 150.h,
                    width: 170.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


