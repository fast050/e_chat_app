import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_email_step/auth_email_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthEmailCubit extends Cubit<AuthEmailState> {

  final AuthRepository _authRepository;

  AuthEmailCubit(this._authRepository) : super(AuthEmailState.initialState());

  Future<void> loginWithEmailMigicLink(String email) async {
     await _authRepository.emailMagicLink(email);
  }
}
