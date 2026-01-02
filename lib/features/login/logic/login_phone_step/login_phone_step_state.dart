class LoginPhoneStepState {
  final String? phoneNumber;
  final bool isPhoneNumberValid;

  const LoginPhoneStepState({
    required this.phoneNumber,
    required this.isPhoneNumberValid,
  });

  LoginPhoneStepState.initialState()
      : phoneNumber = null,
        isPhoneNumberValid = false;

  LoginPhoneStepState copyWith({String? phoneNumber, bool? isPhoneNumberValid}) {
    return LoginPhoneStepState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneNumberValid: isPhoneNumberValid ?? false,
    );
  }
}
