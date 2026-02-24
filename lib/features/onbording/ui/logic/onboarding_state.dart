enum OnboardingStatus { initial ,  success , error }

class OnboardingState {
  final bool hasSeen;
  final OnboardingStatus status;
  final String? errorMessage;

  const OnboardingState({
    required this.hasSeen,
    required this.status,
    this.errorMessage,
  });

  const OnboardingState.initialState()
      : hasSeen = false,
        status = OnboardingStatus.initial,
        errorMessage = null;

  OnboardingState copyWith({
    bool? hasSeen,
    OnboardingStatus? status,
    String? errorMessage,
  }) {
    return OnboardingState(
      hasSeen: hasSeen ?? this.hasSeen,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
