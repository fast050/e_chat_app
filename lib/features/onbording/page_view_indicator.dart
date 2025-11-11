import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageViewIndecatior extends StatelessWidget {
  const PageViewIndecatior({
    super.key,
    required this.textTheme,
    required this.currentPageIndex,
    required this.pageViewSize,
    required this.onTapSkip,
    required this.onTapNext,
  });

  final AppTextTheme textTheme;
  final int currentPageIndex;
  final int pageViewSize;
  final Function() onTapSkip;
  final Function() onTapNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onTapSkip,
          child: Text(
            "Skip",
            style: textTheme.font16Medium,
          ),
        ),
        const Spacer(),
        for (int i = 0; i < pageViewSize; i++) ...{
          if (i == currentPageIndex)
            Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder(
                  tween: IntTween(begin: 0, end: 14),
                  duration: Duration(milliseconds: 300),
                  builder: (_, int sizeValue, __) {
                    return Container(
                      width: sizeValue.w,
                      height: sizeValue.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightBlue300,
                      ),
                    );
                  },
                  child: Container(
                    width: 13.w,
                    height: 13.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightBlue300,
                    ),
                  ),
                ),
                Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lightBlue500,
                  ),
                ),
              ],
            )
          else
            Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightBlue300,
              ),
            ),
          if (i != pageViewSize - 1)
            SizedBox(
              width: 8.h,
            )
        },
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
              style: textTheme.font16Medium.copyWith(
                color: AppColors.lightBlue900,
              ),
            ))
      ],
    );
  }
}
