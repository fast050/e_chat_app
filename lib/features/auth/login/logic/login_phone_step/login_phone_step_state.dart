class LoginPhoneStepState {
  final bool isPhoneNumberValid;

  const LoginPhoneStepState({
    required this.isPhoneNumberValid,
  });

  LoginPhoneStepState.initialState() : isPhoneNumberValid = false;

  LoginPhoneStepState copyWith({bool? isPhoneNumberValid}) {
    return LoginPhoneStepState(
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
    );
  }
}
