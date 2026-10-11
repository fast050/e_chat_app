class AuthPhoneStepState {
  final bool isPhoneNumberValid;

  const AuthPhoneStepState({
    required this.isPhoneNumberValid,
  });

  AuthPhoneStepState.initialState() : isPhoneNumberValid = false;

  AuthPhoneStepState copyWith({bool? isPhoneNumberValid}) {
    return AuthPhoneStepState(
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
    );
  }
}
