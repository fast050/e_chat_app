import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/widgets/gradient_button.dart';
import 'package:e_chat_app/features/onbording/ui/page_view_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_chat_app/core/theme/colors.dart';

class OnboradingBottom extends StatelessWidget {
  final Function() onTapSkip;
  final Function() onTapNext;
  final int currentPageIndex;
  final int pageViewSize;
  const OnboradingBottom(
      {super.key,
      required this.onTapSkip,
      required this.onTapNext,
      required this.currentPageIndex, 
      required this.pageViewSize});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(24.h, 50.h, 24.h, 45.h),
      child: Column(
        children: [
          GradientButton(onPressed: onTapSkip, text: 'Get started'),
          const Spacer(),
          Row(
            children: [
              TextButton(
                onPressed: onTapSkip,
                style: TextButton.styleFrom(
                    fixedSize: const Size(60, 60),
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero),
                child: Text(
                  "Skip",
                  style: textTheme.font16Medium,
                ),
              ),
              const Spacer(),
              PageViewIndicatior(
                textTheme: textTheme,
                currentPageIndex: currentPageIndex,
                pageViewSize: pageViewSize,
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                    fixedSize: const Size(60, 60),
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.lightBlue200),
                onPressed: onTapNext,
                child: Text(
                  "Next",
                  textAlign: TextAlign.center,
                  style: textTheme.font16Medium
                      .copyWith(color: AppColors.lightBlue900),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
