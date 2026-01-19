import 'dart:async';

import 'package:e_chat_app/features/auth/domain/entities/otp_even.dart';
import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  String _verificationId = "";
  int? _resendToken;

  AuthRepositoryImpl(this._auth);

  @override
  Stream<OTPEven> sendOTP(String phoneNumber) {
    final controller = StreamController<OTPEven>();

    controller.add(OTPSending());

    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        controller.add(
          OTPAutoVerfiyed(smsCode: credential.smsCode),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          controller.add(
            OTPFailed(errorMessage: 'The provided phone number is not valid.'),
          );
        }

        print("sendOTP repo ${e.message}");
        // other error should be handle here by send the message only
      },
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        _resendToken = resendToken;

        controller.add(OTPReceived());
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      forceResendingToken: _resendToken,
    );

    return controller.stream;
  }

  @override
  Future<OTPEven> verifyOTP({
    required String smsCode,
  }) async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      // Sign the user in (or link) with the credential
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        return OTPFailed(errorMessage: "Invalid OTP code");
      }

      return OTPFailed(errorMessage: e.message ?? "OTP verification failed");
    }

    return OTPVerfiyed();
  }

  @override
  bool get isSignedIn => _auth.currentUser != null;

  @override
  Future<void> signOut() async {
    _auth.signOut();
  }
}
