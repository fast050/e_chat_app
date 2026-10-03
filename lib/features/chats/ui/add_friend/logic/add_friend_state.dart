import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/entities/friend.dart';

enum AddFriendStatus { initial, loading, success, failure }

class AddFriendState {
  final AddFriendStatus status;
  final String dialCode;
  // Digits typed after the dial code.
  final String number;
  final List<Friend> results;
  final Set<String> addedIds;
  final UiError? error;

  const AddFriendState({
    required this.status,
    required this.dialCode,
    required this.number,
    required this.results,
    required this.addedIds,
    this.error,
  });

  const AddFriendState.initialState()
      : status = AddFriendStatus.initial,
        dialCode = '',
        number = '',
        results = const [],
        addedIds = const {},
        error = null;

  AddFriendState copyWith({
    AddFriendStatus? status,
    String? dialCode,
    String? number,
    List<Friend>? results,
    Set<String>? addedIds,
    UiError? error,
  }) {
    return AddFriendState(
      status: status ?? this.status,
      dialCode: dialCode ?? this.dialCode,
      number: number ?? this.number,
      results: results ?? this.results,
      addedIds: addedIds ?? this.addedIds,
      error: error ?? this.error,
    );
  }
}
