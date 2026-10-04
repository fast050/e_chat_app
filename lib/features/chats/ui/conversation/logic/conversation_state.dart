import 'package:e_chat_app/core/helper/ui_error.dart';

enum ConversationStatus { initial, loading, success, failure }

class MessageItem {
  final String id;
  final String text;
  final String timeLabel;
  final bool isMine;

  const MessageItem({
    required this.id,
    required this.text,
    required this.timeLabel,
    required this.isMine,
  });
}

class ConversationState {
  final ConversationStatus status;
  // Newest first: the list is drawn reversed, so index 0 sits at the bottom.
  final List<MessageItem> messages;
  final UiError? error;

  const ConversationState({
    required this.status,
    required this.messages,
    this.error,
  });

  const ConversationState.initialState()
      : status = ConversationStatus.initial,
        messages = const [],
        error = null;

  ConversationState copyWith({
    ConversationStatus? status,
    List<MessageItem>? messages,
    UiError? error,
  }) {
    return ConversationState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      error: error ?? this.error,
    );
  }
}
