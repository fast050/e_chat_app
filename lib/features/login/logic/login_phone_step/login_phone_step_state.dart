class LoginPhoneStepState {
  final String? phoneNumber;
  final bool isPhoneNumberValid;

  const LoginPhoneStepState({
     this.phoneNumber,
     required this.isPhoneNumberValid,
  });

  LoginPhoneStepState.initialState()
      : phoneNumber = null,
        isPhoneNumberValid = false;

  LoginPhoneStepState copyWith(
      {String? phoneNumber,
      String? formatedPhoneNumber,
      bool? isPhoneNumberValid}) {
    return LoginPhoneStepState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
    );
  }
}
