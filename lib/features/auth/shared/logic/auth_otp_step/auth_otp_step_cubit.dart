import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthOTPStepCubit extends Cubit<AuthOTPStepState> {
  AuthOTPStepCubit() : super(AuthOTPStepState.initialState()) {
    shouldRequestOTP(true); // as this screen open should request otp
  }

  void onSubmitFormatedPhoneNumber(String formatedPhoneNumber) {
    emit(state.copyWith(formatedPhoneNumber: formatedPhoneNumber));
  }

  void onSubmitPhoneNumber(String phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber.trim().replaceAll(" ", "")));
  }

  Future<void> shouldRequestOTP(bool isEnable) async {
    emit(state.copyWith(isRetryOTPEnable: !isEnable));

    if (isEnable) {
      _resetTimer();
    }
  }

  void performOtpCheck(bool isVerify) {
    emit(state.copyWith(isValidOTP: isVerify));
  }

  // reset timer , retry text , arrow button
  void _resetTimer() {
    emit(
      state.copyWith(
        timerResetRequest: state.timerResetRequest + 1,
      ),
    );
  }
}
