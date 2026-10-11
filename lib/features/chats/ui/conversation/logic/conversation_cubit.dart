import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/entities/message.dart';
import 'package:e_chat_app/features/chats/domain/repo/messages_repository.dart';
import 'package:e_chat_app/features/chats/ui/conversation/logic/conversation_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/chat_time_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final MessagesRepository _repository;
  String? _chatId;

  ConversationCubit(this._repository)
      : super(const ConversationState.initialState());

  Future<void> loadMessages(String chatId) async {
    _chatId = chatId;
    emit(state.copyWith(status: ConversationStatus.loading));
    try {
      final messages = await _repository.fetchMessages(chatId);
      if (isClosed) return;
      final newestFirst = [...messages]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(state.copyWith(
        status: ConversationStatus.success,
        messages: newestFirst.map(_toItem).toList(),
      ));
    } on AuthException catch (e) {
      _emitError(e.message, status: ConversationStatus.failure);
    } on PostgrestException catch (e) {
      _emitError(e.message, status: ConversationStatus.failure);
    } catch (_) {
      _emitError(_genericMessage, status: ConversationStatus.failure);
    }
  }

  Future<void> sendMessage(String text) async {
    final chatId = _chatId;
    final trimmed = text.trim();
    if (chatId == null || trimmed.isEmpty) return;

    try {
      final message =
          await _repository.sendMessage(chatId: chatId, text: trimmed);
      if (isClosed) return;
      emit(state.copyWith(messages: [_toItem(message), ...state.messages]));
    } on AuthException catch (e) {
      _emitError(e.message);
    } on PostgrestException catch (e) {
      _emitError(e.message);
    } catch (_) {
      _emitError(_genericMessage);
    }
  }

  static const _genericMessage = 'Something went wrong. Please try again.';

  MessageItem _toItem(Message message) => MessageItem(
        id: message.id,
        text: message.text,
        timeLabel: formatMessageTime(message.createdAt.toLocal()),
        isMine: message.senderId == _repository.currentUserId,
        imageUrl: message.imageUrl,
      );

  void _emitError(String message, {ConversationStatus? status}) {
    if (isClosed) return;
    emit(state.copyWith(status: status, error: UiError(message)));
  }
}
