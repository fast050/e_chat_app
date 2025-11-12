class OnBoardingStepDetailsModel {
  final String imagePath;
  final String title;
  final String subTitle;

  OnBoardingStepDetailsModel({
    required this.imagePath,
    required this.title,
    required this.subTitle,
  }); 
}


final List<OnBoardingStepDetailsModel> onBoardingStepDetailsData = [
    OnBoardingStepDetailsModel(
      imagePath: 'assets/images/onboarding_step1.png',
      title: 'Group Chatting',
      subTitle: 'Connect with multiple members in\ngroup chats.',
    ),
    OnBoardingStepDetailsModel(
      imagePath: 'assets/images/onboarding_step2.png',
      title: 'Video And Voice Calls',
      subTitle: 'Instantly connect via video and voice calls.',
    ),
    OnBoardingStepDetailsModel(
      imagePath: 'assets/images/onboarding_step3.png',
      title: 'Message Encryption',
      subTitle: 'Ensure privacy with encrypted messages.',
    ),
    OnBoardingStepDetailsModel(
      imagePath: 'assets/images/onboarding_step4.png',
      title: 'Cross-Platform Compatibility',
      subTitle: 'Access your chats on any device seamlessly.',
    ),
  ];