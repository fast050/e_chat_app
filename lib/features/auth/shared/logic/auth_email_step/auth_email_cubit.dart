import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_email_step/auth_email_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthEmailCubit extends Cubit<AuthEmailState> {
  final AuthRepository _authRepository;

  AuthEmailCubit(this._authRepository) : super(AuthEmailState.initialState());

  Future<void> loginWithEmailMigicLink(String email) async {
    emit(state.copyWith(isSubmitting: true, linkSent: false));
    try {
      await _authRepository.emailMagicLink(email);
      emit(state.copyWith(isSubmitting: false, linkSent: true));
    } on AuthException catch (e) {
      emit(state.copyWith(isSubmitting: false, error: UiError(e.message)));
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        error: UiError('Something went wrong. Please try again.'),
      ));
    }
  }
}
