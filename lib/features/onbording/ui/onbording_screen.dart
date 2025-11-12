import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/widgets/gradient_button.dart';
import 'package:e_chat_app/features/onbording/ui/onboarding_step_details.dart';
import 'package:e_chat_app/features/onbording/date/onboarding_step_details_model.dart';
import 'package:e_chat_app/features/onbording/ui/page_view_indicator.dart';
import 'package:e_chat_app/features/onbording/ui/stack_with_background_shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  final List<OnBoardingStepDetailsModel> _onBoardingDetailsList =
      onBoardingStepDetailsData;
  int _currentPageIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    for (int i = 0; i < 4; i++) {
      precacheImage(AssetImage(_onBoardingDetailsList[i].imagePath), context);
    }


    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPageIndex = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTapNext() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void onTapSkip() {}

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Scaffold(
      body: StackWithBackgroundShapes(
        child: Column(children: [
          Expanded(
            flex: 2,
            child: PageView.builder(
              controller: _pageController,
              allowImplicitScrolling: true,
              itemCount: _onBoardingDetailsList.length,
              itemBuilder: (_, index) {
                return OnboardingStepDetails(
                    pageController: _pageController,
                    imagePath: _onBoardingDetailsList[index].imagePath,
                    title: _onBoardingDetailsList[index].title,
                    subTitle: _onBoardingDetailsList[index].subTitle);
              },
            ),
          ),
          Expanded(
            child: Padding(
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
                        currentPageIndex: _currentPageIndex,
                        pageViewSize: onBoardingStepDetailsData.length,
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
            ),
          )
        ]),
      ),
    );
  }
}
