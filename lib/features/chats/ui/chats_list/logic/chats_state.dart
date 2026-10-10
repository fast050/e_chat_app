import 'package:e_chat_app/core/helper/ui_error.dart';

enum ChatsStatus { initial, loading, success, failure }

class ChatPreview {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;

  const ChatPreview({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    required this.unreadCount,
    this.avatarUrl,
    this.phoneNumber,
  });
}

class ChatsState {
  final ChatsStatus status;
  final List<ChatPreview> allChats;
  // What the list shows: allChats filtered by searchQuery.
  final List<ChatPreview> chats;
  final String searchQuery;
  final bool isSearchOpen;
  final bool isAddMenuOpen;
  final UiError? error;

  const ChatsState({
    required this.status,
    required this.allChats,
    required this.chats,
    required this.searchQuery,
    required this.isSearchOpen,
    required this.isAddMenuOpen,
    this.error,
  });

  const ChatsState.initialState()
      : status = ChatsStatus.initial,
        allChats = const [],
        chats = const [],
        searchQuery = '',
        isSearchOpen = false,
        isAddMenuOpen = false,
        error = null;

  ChatsState copyWith({
    ChatsStatus? status,
    List<ChatPreview>? allChats,
    List<ChatPreview>? chats,
    String? searchQuery,
    bool? isSearchOpen,
    bool? isAddMenuOpen,
    UiError? error,
  }) {
    return ChatsState(
      status: status ?? this.status,
      allChats: allChats ?? this.allChats,
      chats: chats ?? this.chats,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchOpen: isSearchOpen ?? this.isSearchOpen,
      isAddMenuOpen: isAddMenuOpen ?? this.isAddMenuOpen,
      error: error ?? this.error,
    );
  }
}
