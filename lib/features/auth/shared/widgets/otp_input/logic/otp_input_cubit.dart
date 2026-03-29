import 'dart:async';
import 'package:e_chat_app/features/auth/domain/entities/otp_even.dart';
import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:e_chat_app/features/auth/shared/widgets/otp_input/logic/otp_input_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPInputCubit extends Cubit<OTPInputState> {
  final AuthRepository _repo;
  late final StreamSubscription<OTPEven> _otpEvenStream;
  OTPInputCubit(this._repo) : super(OTPInputState.initialState());

  void sendOTP({required String? phoneNumber , bool? shouldCreateUser}) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      emit(
        state.copyWith(
          isVerifyOTP: false,
          state: OtpStatus.failed,
          errorMessage: "Phone number is required",
        ),
      );
      return;
    }

    _otpEvenStream = _repo.sendOTP(phoneNumber: phoneNumber , shouldCreateUser: shouldCreateUser).listen((otpEven) {
      switch (otpEven) {
        case OTPSending():
          {
            emit(state.copyWith(
                isVerifyOTP: false,
                state: OtpStatus.sending,
                errorMessage: null));
          }
        case OTPReceived():
          {
            // verifyOTP should when this event happened
            emit(state.copyWith(
                isVerifyOTP: false,
                state: OtpStatus.received,
                errorMessage: null));
          }
        case OTPFailed(errorMessage: final errorMessage):
          {
            emit(state.copyWith(
              isVerifyOTP: false,
              state: OtpStatus.failed,
              errorMessage: errorMessage,
            ));
          }
        case OTPAutoVerfiyed(smsCode: final smsCode):
          {
            emit(
              state.copyWith(
                  isVerifyOTP: true,
                  state: OtpStatus.autoVerify,
                  smsCode: smsCode),
            );
          }
        default: // do nothing
      }
    });
  }

  void verifyOTP(String smsCode) async {
    final result = await _repo.verifyOTP(smsCode: smsCode);

    if (result is OTPVerfiyed) {
      emit(
        state.copyWith(
          isVerifyOTP: true,
          state: OtpStatus.verify,
          errorMessage: null,
        ),
      );
    } else if (result is OTPFailed) {
      emit(
        state.copyWith(
            isVerifyOTP: false,
            state: OtpStatus.failed,
            errorMessage: result.errorMessage),
      );
    }
  }

  @override
  Future<void> close() {
    _otpEvenStream.cancel();
    return super.close();
  }
}
