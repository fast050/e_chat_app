
class AuthEmailState {
  final String email;
  final bool isEmailValid;

  const AuthEmailState({
    required this.email,
    required this.isEmailValid,
  });

  AuthEmailState.initialState()
      :  email = '',
        isEmailValid = false;

  AuthEmailState copyWith({
    String? email,
    bool? isEmailValid,
  }) {
    return AuthEmailState(
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}
