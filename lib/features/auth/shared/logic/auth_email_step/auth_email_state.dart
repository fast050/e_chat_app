import 'package:e_chat_app/core/helper/ui_error.dart';

class AuthEmailState {
  final bool isSubmitting;
  final bool linkSent;
  final UiError? error;

  const AuthEmailState({
    required this.isSubmitting,
    required this.linkSent,
    this.error,
  });

  AuthEmailState.initialState()
      : isSubmitting = false,
        linkSent = false,
        error = null;

  AuthEmailState copyWith({
    bool? isSubmitting,
    bool? linkSent,
    UiError? error,
  }) {
    return AuthEmailState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      linkSent: linkSent ?? this.linkSent,
      error: error ?? this.error,
    );
  }
}
