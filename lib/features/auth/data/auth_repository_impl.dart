import 'dart:async';

import 'package:e_chat_app/features/auth/domain/entities/otp_even.dart';
import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  String _verificationId = '';
  int? _resendToken;
  UserCredential? userCredential;

  int _attempt = 0; // internal guard: latest OTP request wins

  AuthRepositoryImpl(this._auth);

  void _safeAdd(StreamController<OTPEven> controller, OTPEven event) {
    if (!controller.isClosed) controller.add(event);
  }

  Future<void> _safeClose(StreamController<OTPEven> controller) async {
    if (!controller.isClosed) await controller.close();
  }

  bool _isStale(int attemptId) => attemptId != _attempt;

  @override
  Stream<OTPEven> sendOTP(String phoneNumber) {
    final controller = StreamController<OTPEven>();
    final attemptId = ++_attempt;

    // Reset per attempt to avoid verifying with an old verificationId.
    _verificationId = '';

    _safeAdd(controller, OTPSending());

    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: _resendToken,

      verificationCompleted: (credential) async {
        if (_isStale(attemptId)) return;

        try {
          userCredential = await _auth.signInWithCredential(credential);
          _safeAdd(controller, OTPAutoVerfiyed(smsCode: credential.smsCode));
        } on FirebaseAuthException catch (e) {
          _safeAdd(controller, OTPFailed(errorMessage: e.message ?? 'Auto verification failed'));
        } catch (_) {
          _safeAdd(controller, OTPFailed(errorMessage: 'Auto verification failed'));
        } finally {
          await _safeClose(controller);
        }
      },

      verificationFailed: (e) async {
        if (_isStale(attemptId)) return;

        _safeAdd(controller, OTPFailed(errorMessage: e.message ?? 'OTP failed'));
        await _safeClose(controller);
      },

      codeSent: (verificationId, resendToken) {
        if (_isStale(attemptId)) return;

        _verificationId = verificationId;
        _resendToken = resendToken;

        _safeAdd(controller, OTPReceived());
      },

      codeAutoRetrievalTimeout: (_) {},
    );

    return controller.stream;
  }

  @override
  Future<OTPEven> verifyOTP({required String smsCode}) async {
    if (_verificationId.isEmpty) {
      return OTPFailed(errorMessage: 'Please request OTP first.');
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      userCredential = await _auth.signInWithCredential(credential);
      return OTPVerfiyed();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        return OTPFailed(errorMessage: 'Invalid OTP code');
      }
      return OTPFailed(errorMessage: e.message ?? 'OTP verification failed');
    } catch (_) {
      return OTPFailed(errorMessage: 'OTP verification failed');
    }
  }

  @override
  bool get isSignedIn => _auth.currentUser != null;

  @override
  bool get isNewUser => userCredential?.additionalUserInfo?.isNewUser == true;

  @override
  Future<void> signOut() => _auth.signOut();
}
