sealed class OTPEven {
  const OTPEven();
}

class OTPSending extends OTPEven {
  const OTPSending();
}

class OTPFailed extends OTPEven {
  final String errorMessage;
  const OTPFailed({required this.errorMessage});
}

class OTPReceived extends OTPEven {
  const OTPReceived();
}

class OTPAutoVerfiyed extends OTPEven {
  final String? smsCode;
  const OTPAutoVerfiyed({required this.smsCode});
}

class OTPVerfiyed extends OTPEven {
  const OTPVerfiyed();
}
