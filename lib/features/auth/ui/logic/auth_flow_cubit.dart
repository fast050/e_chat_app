import 'package:e_chat_app/features/auth/ui/logic/auth_flow_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthFlowCubit extends Cubit<AuthFlowState> {
  AuthFlowCubit() : super(AuthFlowState.initialState());

  void setInitialTab(AuthTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  void showLoginTab() {
    emit(
      state.copyWith(
        currentTab: AuthTab.login,
        loginStepView: LoginStepView.phone,
      ),
    );
  }

  void showRegisterTab() {
    emit(
      state.copyWith(
        currentTab: AuthTab.register,
        registerStepView: RegisterStepView.phone,
      ),
    );
  }

  void goToLoginOTP() {
    emit(
      state.copyWith(
        currentTab: AuthTab.login,
        loginStepView: LoginStepView.otp,
      ),
    );
  }

  void backToLoginPhone() {
    emit(state.copyWith(loginStepView: LoginStepView.phone));
  }

  void goToRegisterOTP() {
    emit(
      state.copyWith(
        currentTab: AuthTab.register,
        registerStepView: RegisterStepView.otp,
      ),
    );
  }

  void goToRegisterUserInformation() {
    emit(
      state.copyWith(
        currentTab: AuthTab.register,
        registerStepView: RegisterStepView.userInformation,
      ),
    );
  }

  void backToRegisterOTP() {
    emit(state.copyWith(registerStepView: RegisterStepView.otp));
  }

  void backRegisterStep() {
    if (state.registerStepView == RegisterStepView.userInformation) {
      backToRegisterOTP();
      return;
    }

    if (state.registerStepView == RegisterStepView.otp) {
      emit(state.copyWith(registerStepView: RegisterStepView.phone));
    }
  }
}
