class LoginOTPStepState {
  final String? formatedPhoneNumber;
  final String? phoneNumber;
  final bool isRetryOTPEnable;
  final bool isValidOTP;
  final int timerResetRequest; // each time it will increase the timer will reset

  const LoginOTPStepState(
  {
    required this.timerResetRequest, 
    required this.isRetryOTPEnable,
    required this.isValidOTP,
    this.formatedPhoneNumber,
    this.phoneNumber,
  });

  LoginOTPStepState.initialState()
      : formatedPhoneNumber = null,
        phoneNumber = null,
        isValidOTP = false,
        isRetryOTPEnable = false,
        timerResetRequest = 0;

  LoginOTPStepState copyWith({
    String? formatedPhoneNumber,
    String? phoneNumber,
    bool? isValidOTP,
    bool? isRetryOTPEnable,
    int? timerResetRequest,
  }) {
    return LoginOTPStepState(
      formatedPhoneNumber: formatedPhoneNumber ?? this.formatedPhoneNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isValidOTP: isValidOTP ?? this.isValidOTP,
      isRetryOTPEnable: isRetryOTPEnable ?? this.isRetryOTPEnable,
      timerResetRequest: timerResetRequest ?? this.timerResetRequest
    );
  }
}
