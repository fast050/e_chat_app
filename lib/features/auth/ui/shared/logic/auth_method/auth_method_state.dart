enum AuthMethod { phone, email }

class AuthMethodState {
  final AuthMethod loginMethod;
  final String email;
  final bool isEmailValid;

  const AuthMethodState({
    required this.loginMethod,
    required this.email,
    required this.isEmailValid,
  });

  AuthMethodState.initialState()
      : loginMethod = AuthMethod.phone,
        email = '',
        isEmailValid = false;

  AuthMethodState copyWith({
    AuthMethod? loginMethod,
    String? email,
    bool? isEmailValid,
  }) {
    return AuthMethodState(
      loginMethod: loginMethod ?? this.loginMethod,
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}
