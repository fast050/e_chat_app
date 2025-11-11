class OnBoardingModel {
  final String imagePath;
  final String title;
  final String subTitle;

  OnBoardingModel({
    required this.imagePath,
    required this.title,
    required this.subTitle,
  }); 
}


final List<OnBoardingModel> onBoardingData = [
    OnBoardingModel(
      imagePath: 'assets/images/onboarding_step1.png',
      title: 'Group Chatting',
      subTitle: 'Connect with multiple members in\ngroup chats.',
    ),
    OnBoardingModel(
      imagePath: 'assets/images/onboarding_step2.png',
      title: 'Video And Voice Calls',
      subTitle: 'Instantly connect via video and voice calls.',
    ),
    OnBoardingModel(
      imagePath: 'assets/images/onboarding_step3.png',
      title: 'Message Encryption',
      subTitle: 'Ensure privacy with encrypted messages.',
    ),
    OnBoardingModel(
      imagePath: 'assets/images/onboarding_step4.png',
      title: 'Cross-Platform Compatibility',
      subTitle: 'Access your chats on any device seamlessly.',
    ),
  ];