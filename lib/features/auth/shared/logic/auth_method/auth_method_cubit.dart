import 'package:e_chat_app/features/auth/shared/logic/auth_method/auth_method_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthMethodCubit extends Cubit<AuthMethodState> {
  AuthMethodCubit() : super(AuthMethodState.initialState());

  void toggleLoginMethod() {
    emit(
      state.copyWith(
        loginMethod: state.loginMethod == AuthMethod.phone
            ? AuthMethod.email
            : AuthMethod.phone,
      ),
    );
  }

  void onEmailChanged({
    required String email,
    required bool isEmailValid,
  }) {
    emit(
      state.copyWith(
        email: email,
        isEmailValid: isEmailValid,
      ),
    );
  }
}
