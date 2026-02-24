 
abstract interface class OnboardingRepository {
  Future<bool> hasSeenOnboarding();
  Future<bool> setHasSeenOnboarding();
}