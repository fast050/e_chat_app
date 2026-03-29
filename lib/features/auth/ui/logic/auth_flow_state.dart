enum AuthTab { login, register }

enum LoginStepView { phone, otp }

enum RegisterStepView { phone, otp, userInformation }

class AuthFlowState {
  final AuthTab currentTab;
  final LoginStepView loginStepView;
  final RegisterStepView registerStepView;

  const AuthFlowState({
    required this.currentTab,
    required this.loginStepView,
    required this.registerStepView,
  });

  AuthFlowState.initialState()
      : currentTab = AuthTab.login,
        loginStepView = LoginStepView.phone,
        registerStepView = RegisterStepView.phone;

  AuthFlowState copyWith({
    AuthTab? currentTab,
    LoginStepView? loginStepView,
    RegisterStepView? registerStepView,
  }) {
    return AuthFlowState(
      currentTab: currentTab ?? this.currentTab,
      loginStepView: loginStepView ?? this.loginStepView,
      registerStepView: registerStepView ?? this.registerStepView,
    );
  }
}
