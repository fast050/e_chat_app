import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';

enum ChatSettingsStatus { loading, success, failure }

class ChatSettingsState {
  final ChatSettingsStatus status;
  final ChatSettings settings;
  final UiError? error;

  const ChatSettingsState({
    required this.status,
    required this.settings,
    this.error,
  });

  const ChatSettingsState.initialState()
      : status = ChatSettingsStatus.loading,
        settings = const ChatSettings(chatId: ''),
        error = null;

  ChatSettingsState copyWith({
    ChatSettingsStatus? status,
    ChatSettings? settings,
    UiError? error,
  }) {
    return ChatSettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      error: error ?? this.error,
    );
  }
}
