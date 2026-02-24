import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/features/onbording/date/onboarding_step_details_model.dart';
import 'package:e_chat_app/features/onbording/ui/logic/onboarding_cubit.dart';
import 'package:e_chat_app/features/onbording/ui/logic/onboarding_state.dart';
import 'package:e_chat_app/features/onbording/ui/onboarding_step_details.dart';
import 'package:e_chat_app/features/onbording/ui/onborading_bottom.dart';
import 'package:e_chat_app/features/onbording/ui/stack_with_background_shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    
    _pageController.addListener(setCurrentPageIndex);
  }

  void setCurrentPageIndex() {
    if (_pageController.page != null) {
      setState(() {
        _currentPageIndex = _pageController.page!.round();
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(setCurrentPageIndex);
    _pageController.dispose();
    super.dispose();
  }

  void onTapNext() async {
    if (_currentPageIndex == _onBoardingDetailsList.length - 1) {
      context.read<OnboardingCubit>().setHasSeenOnboarding();
    } else {
      _pageController.nextPage(
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    }
  }

  void onTapSkip() async {
    context.read<OnboardingCubit>().setHasSeenOnboarding();
  }

  @override
  Widget build(BuildContext context) {
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
            child: OnboradingBottom(
              onTapNext: onTapNext,
              onTapSkip: onTapSkip,
              currentPageIndex: _currentPageIndex,
              pageViewSize: _onBoardingDetailsList.length,
            ),
          ),
          BlocListener<OnboardingCubit, OnboardingState>(
            listenWhen: (prev, current) => current.hasSeen == true,
            listener: (context, state) {
              if (state.status == OnboardingStatus.success) {
                context.pushReplacementNamed(Routes.auth); // leave the page
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Something wrong happen"),
                    action: SnackBarAction(
                        label: "Referesh",
                        onPressed: () {
                          context
                              .read<OnboardingCubit>()
                              .setHasSeenOnboarding();
                        }),
                  ),
                );
              }
            },
            child: const SizedBox.shrink(),
          )
        ]),
      ),
    );
  }
}
