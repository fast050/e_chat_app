import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/entities/friend.dart';

enum CreateGroupStatus { initial, submitting, success, failure }

class CreateGroupState {
  final CreateGroupStatus status;
  final String name;
  final bool isLoadingFriends;
  final List<Friend> friends;
  // What the member picker shows: friends filtered by its search field.
  final List<Friend> pickerFriends;
  // Ticked in the open picker; becomes members only on confirm.
  final Set<String> pickerSelectedIds;
  final List<Friend> members;
  final UiError? error;

  const CreateGroupState({
    required this.status,
    required this.name,
    required this.isLoadingFriends,
    required this.friends,
    required this.pickerFriends,
    required this.pickerSelectedIds,
    required this.members,
    this.error,
  });

  const CreateGroupState.initialState()
      : status = CreateGroupStatus.initial,
        name = '',
        isLoadingFriends = false,
        friends = const [],
        pickerFriends = const [],
        pickerSelectedIds = const {},
        members = const [],
        error = null;

  CreateGroupState copyWith({
    CreateGroupStatus? status,
    String? name,
    bool? isLoadingFriends,
    List<Friend>? friends,
    List<Friend>? pickerFriends,
    Set<String>? pickerSelectedIds,
    List<Friend>? members,
    UiError? error,
  }) {
    return CreateGroupState(
      status: status ?? this.status,
      name: name ?? this.name,
      isLoadingFriends: isLoadingFriends ?? this.isLoadingFriends,
      friends: friends ?? this.friends,
      pickerFriends: pickerFriends ?? this.pickerFriends,
      pickerSelectedIds: pickerSelectedIds ?? this.pickerSelectedIds,
      members: members ?? this.members,
      error: error ?? this.error,
    );
  }
}
