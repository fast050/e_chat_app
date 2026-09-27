import 'package:e_chat_app/features/chats/ui/helper/chat_time_format.dart';
import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/entities/chat.dart';
import 'package:e_chat_app/features/chats/domain/repo/chats_repository.dart';
import 'package:e_chat_app/features/chats/ui/logic/chats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatsRepository _repository;
  final DateTime Function() _now;

  ChatsCubit(this._repository, {DateTime Function() now = DateTime.now})
      : _now = now,
        super(const ChatsState.initialState());

  Future<void> loadChats() async {
    emit(state.copyWith(status: ChatsStatus.loading));
    try {
      final allChats = _toPreviews(await _repository.fetchChats());
      emit(state.copyWith(
        status: ChatsStatus.success,
        allChats: allChats,
        chats: _filter(allChats, state.searchQuery),
      ));
    } on AuthException catch (e) {
      _emitFailure(e.message);
    } on PostgrestException catch (e) {
      _emitFailure(e.message);
    } catch (_) {
      _emitFailure('Something went wrong. Please try again.');
    }
  }

  void openSearch() {
    emit(state.copyWith(isSearchOpen: true, isAddMenuOpen: false));
  }

  void closeSearch() {
    emit(state.copyWith(
      isSearchOpen: false,
      searchQuery: '',
      chats: state.allChats,
    ));
  }

  void search(String query) {
    emit(state.copyWith(
      searchQuery: query,
      chats: _filter(state.allChats, query),
    ));
  }

  void toggleAddMenu() {
    emit(state.copyWith(isAddMenuOpen: !state.isAddMenuOpen));
  }

  void closeAddMenu() {
    if (!state.isAddMenuOpen) return;
    emit(state.copyWith(isAddMenuOpen: false));
  }

  List<ChatPreview> _filter(List<ChatPreview> chats, String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return chats;
    return chats
        .where((chat) =>
            chat.name.toLowerCase().contains(needle) ||
            chat.lastMessage.toLowerCase().contains(needle))
        .toList();
  }

  List<ChatPreview> _toPreviews(List<Chat> chats) {
    final now = _now();
    final sorted = [...chats]
      ..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    return sorted
        .map((chat) => ChatPreview(
              id: chat.id,
              name: chat.name,
              avatarUrl: chat.avatarUrl,
              lastMessage: chat.lastMessage,
              timeLabel: formatChatTime(chat.lastMessageAt, now: now),
              unreadCount: chat.unreadCount,
            ))
        .toList();
  }

  void _emitFailure(String message) {
    emit(state.copyWith(status: ChatsStatus.failure, error: UiError(message)));
  }
}
