class OTPInputState {
  final bool isVerifyOTP;
  final String phoneNumber;

  const OTPInputState({required this.phoneNumber, required this.isVerifyOTP});

  OTPInputState.initialState()
      : isVerifyOTP = false,
        phoneNumber = "";

  OTPInputState copyWith(bool? isVerifyOTP, String? phoneNumber) {
    return OTPInputState(
      isVerifyOTP: isVerifyOTP ?? this.isVerifyOTP,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
