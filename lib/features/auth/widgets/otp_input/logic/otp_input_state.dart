enum OtpStatus { initial, sending, received, verify, autoVerify, failed }

class OTPInputState {
  final bool isVerifyOTP;
  final String phoneNumber;
  final String smsCode;
  final String errorMessage;
  final OtpStatus status;

  const OTPInputState({
    required this.smsCode,
    required this.phoneNumber,
    required this.isVerifyOTP,
    required this.status,
    required this.errorMessage,
  });

  OTPInputState.initialState()
      : isVerifyOTP = false,
        phoneNumber = "",
        smsCode = "",
        errorMessage = "",
        status = OtpStatus.initial;

  OTPInputState copyWith(
      {bool? isVerifyOTP,
      String? phoneNumber,
      String? smsCode,
      OtpStatus? state,
      String? errorMessage}) {
    return OTPInputState(
      isVerifyOTP: isVerifyOTP ?? this.isVerifyOTP,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      smsCode: smsCode ?? this.smsCode,
      status: state ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
