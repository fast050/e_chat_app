enum LoginMethod { phone, email }

class LoginMethodState {
  final LoginMethod loginMethod;
  final String email;
  final bool isEmailValid;

  const LoginMethodState({
    required this.loginMethod,
    required this.email,
    required this.isEmailValid,
  });

  LoginMethodState.initialState()
      : loginMethod = LoginMethod.phone,
        email = '',
        isEmailValid = false;

  LoginMethodState copyWith({
    LoginMethod? loginMethod,
    String? email,
    bool? isEmailValid,
  }) {
    return LoginMethodState(
      loginMethod: loginMethod ?? this.loginMethod,
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}
