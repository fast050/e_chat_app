class AuthOTPStepState {
  final String? formatedPhoneNumber;
  final String? phoneNumber;
  final bool isRetryOTPEnable;
  final bool isValidOTP;
  final int timerResetRequest; // each time it will increase the timer will reset

  const AuthOTPStepState(
  {
    required this.timerResetRequest, 
    required this.isRetryOTPEnable,
    required this.isValidOTP,
    this.formatedPhoneNumber,
    this.phoneNumber,
  });

  AuthOTPStepState.initialState()
      : formatedPhoneNumber = null,
        phoneNumber = null,
        isValidOTP = false,
        isRetryOTPEnable = false,
        timerResetRequest = 0;

  AuthOTPStepState copyWith({
    String? formatedPhoneNumber,
    String? phoneNumber,
    bool? isValidOTP,
    bool? isRetryOTPEnable,
    int? timerResetRequest,
  }) {
    return AuthOTPStepState(
      formatedPhoneNumber: formatedPhoneNumber ?? this.formatedPhoneNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isValidOTP: isValidOTP ?? this.isValidOTP,
      isRetryOTPEnable: isRetryOTPEnable ?? this.isRetryOTPEnable,
      timerResetRequest: timerResetRequest ?? this.timerResetRequest
    );
  }
}
