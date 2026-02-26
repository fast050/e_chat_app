import 'dart:async';

import 'package:e_chat_app/features/auth/domain/entities/otp_even.dart';
import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Firebase removed: provide simple stub implementations for now.
  const AuthRepositoryImpl();

  @override
  Stream<OTPEven> sendOTP(String phoneNumber) async* {
    yield OTPSending();
    yield OTPFailed(errorMessage: 'Auth provider not configured');
  }

  @override
  Future<OTPEven> verifyOTP({required String smsCode}) async {
    return OTPFailed(errorMessage: 'Auth provider not configured');
  }

  @override
  bool get isSignedIn => false;

  @override
  Future<void> signOut() async {}
}
