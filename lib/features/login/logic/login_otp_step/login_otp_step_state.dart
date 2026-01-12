class LoginOTPStepState {
  final String? formatedPhoneNumber;
  final bool isRetryOTPEnable;
  final bool isValidOTP;
  final int timerResetRequest; // each time it will increase the timer will reset

  const LoginOTPStepState(
  {
    required this.timerResetRequest, 
    required this.isRetryOTPEnable,
    required this.isValidOTP,
    this.formatedPhoneNumber,
  });

  LoginOTPStepState.initialState()
      : formatedPhoneNumber = null,
        isValidOTP = false,
        isRetryOTPEnable = false,
        timerResetRequest = 0;

  LoginOTPStepState copyWith({
    String? formatedPhoneNumber,
    bool? isValidOTP,
    bool? isRetryOTPEnable,
    int? timerResetRequest,
  }) {
    return LoginOTPStepState(
      formatedPhoneNumber: formatedPhoneNumber ?? this.formatedPhoneNumber,
      isValidOTP: isValidOTP ?? this.isValidOTP,
      isRetryOTPEnable: isRetryOTPEnable ?? this.isRetryOTPEnable,
      timerResetRequest: timerResetRequest ?? this.timerResetRequest
    );
  }
}
