import 'dart:async';

import 'package:e_chat_app/features/auth/domain/entities/otp_even.dart';
import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;

  // Store phone between sendOTP and verifyOTP calls
  String? _pendingPhone;

  AuthRepositoryImpl(this._supabase);

  @override
  Stream<OTPEven> sendOTP({required String phoneNumber , bool? shouldCreateUser}) async* {
    yield OTPSending();
    try {
      _pendingPhone = phoneNumber;
      await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
        shouldCreateUser: shouldCreateUser ?? false, // set false if only existing users can log in
      );
    } on AuthException catch (e) {
      _pendingPhone = null;
      yield OTPFailed(errorMessage: e.message);
    } catch (e) {
      _pendingPhone = null;
      yield OTPFailed(errorMessage: e.toString());
    }
  }

  @override
  Future<OTPEven> verifyOTP({required String smsCode}) async {
    final phone = _pendingPhone;
    if (phone == null) {
      return OTPFailed(errorMessage: 'No pending OTP. Please request a new one.');
    }
    try {
      final response = await _supabase.auth.verifyOTP(
        phone: phone,
        token: smsCode,
        type: OtpType.sms,
      );
      if (response.user != null) {
        _pendingPhone = null;
        return OTPVerfiyed(); // or whatever your "verified" event is
      }
      return OTPFailed(errorMessage: 'Verification failed. Please try again.');
    } on AuthException catch (e) {
      // Handle expired token specifically
      if (e.statusCode == '403' && e.message.toLowerCase().contains('expired')) {
        return OTPFailed(errorMessage: 'OTP has expired. Please request a new one.');
      }
      return OTPFailed(errorMessage: e.message);
    } catch (e) {
      return OTPFailed(errorMessage: e.toString());
    }
  }

  @override
  bool get isSignedIn => _supabase.auth.currentUser != null;

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}


// import 'dart:async';

// import 'package:e_chat_app/features/auth/domain/entities/otp_even.dart';
// import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final SupabaseClient _supabase;

//   String? _pendingEmail;

//   AuthRepositoryImpl(this._supabase);

//   @override
//   Stream<OTPEven> sendOTP(String email) async* {
//     yield OTPSending();
//     try {
//       _pendingEmail = "khalidwork050@gmail.com";
//       await _supabase.auth.signInWithOtp(
//         email: email,
//         shouldCreateUser: true,
//       );
      
//     } on AuthException catch (e) {
//       _pendingEmail = null;
//       yield OTPFailed(errorMessage: e.message);
//     } catch (e) {
//       _pendingEmail = null;
//       yield OTPFailed(errorMessage: e.toString());
//     }
//   }

//   @override
//   Future<OTPEven> verifyOTP({required String smsCode}) async {
//     final email = _pendingEmail;
//     if (email == null) {
//       return OTPFailed(errorMessage: 'No pending OTP. Please request a new one.');
//     }
//     try {
//       final response = await _supabase.auth.verifyOTP(
//         email: email,
//         token: smsCode,
//         type: OtpType.email, // 👈 changed from OtpType.sms
//       );
//       if (response.user != null) {
//         _pendingEmail = null;
//         return OTPVerfiyed(); // replace with your actual event
//       }
//       return OTPFailed(errorMessage: 'Verification failed. Please try again.');
//     } on AuthException catch (e) {
//       return OTPFailed(errorMessage: e.message);
//     } catch (e) {
//       return OTPFailed(errorMessage: e.toString());
//     }
//   }

//   @override
//   bool get isSignedIn => _supabase.auth.currentUser != null;

//   @override
//   Future<void> signOut() async {
//     await _supabase.auth.signOut();
//   }
// }