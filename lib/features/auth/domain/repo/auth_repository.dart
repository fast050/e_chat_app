import 'package:e_chat_app/features/auth/domain/entities/otp_even.dart';

abstract interface class AuthRepository {
  Stream<OTPEven> sendOTP(String phoneNumber);

  Future<OTPEven> verifyOTP({
    required String smsCode,
  });

  bool get isSignedIn;

  bool get isNewUser;

  Future<void> signOut();
}
