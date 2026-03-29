import 'package:e_chat_app/features/auth/login/logic/login_method/login_method_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginMethodCubit extends Cubit<LoginMethodState> {
  LoginMethodCubit() : super(LoginMethodState.initialState());

  void toggleLoginMethod() {
    emit(
      state.copyWith(
        loginMethod: state.loginMethod == LoginMethod.phone
            ? LoginMethod.email
            : LoginMethod.phone,
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
