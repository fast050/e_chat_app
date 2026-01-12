import 'package:e_chat_app/features/login/logic/login_otp_step/login_otp_step_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginOTPStepCubit extends Cubit<LoginOTPStepState> {
  LoginOTPStepCubit() : super(LoginOTPStepState.initialState()) {
    shouldRequestOTP(true); // as this screen open should request otp
  }

  void onSubmitFormatedPhoneNumber(String formatedPhoneNumber) {
    emit(state.copyWith(formatedPhoneNumber: formatedPhoneNumber));
  }

  void shouldRequestOTP(bool isEnable) {
    emit(state.copyWith(isRetryOTPEnable: !isEnable));

    if (isEnable) {
      _resetUIStateToInitial();
      print("we are requesting OTP");
    }
  }

  // reset timer , retry text , arrow button
  void _resetUIStateToInitial() {
    emit(
      state.copyWith(
        isValidOTP: false,
        timerResetRequest: state.timerResetRequest + 1,
      ),
    );
  }
}
