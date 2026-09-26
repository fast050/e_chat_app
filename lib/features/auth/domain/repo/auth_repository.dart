import 'package:e_chat_app/features/auth/domain/entities/otp_even.dart';

abstract interface class AuthRepository {
  Stream<OTPEven> sendOTP({required String phoneNumber , bool? shouldCreateUser});

  Future<OTPEven> verifyOTP({
    required String smsCode,
  });

  Future<void> emailMagicLink(String email);

  bool get isSignedIn;

  Future<void> signOut();
}
