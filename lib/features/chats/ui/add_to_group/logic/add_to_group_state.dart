import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/entities/group.dart';

enum AddToGroupStatus { loading, success, failure }

class AddToGroupState {
  final AddToGroupStatus status;
  final List<Group> allGroups;
  // [allGroups] filtered by [searchQuery]; what the list shows.
  final List<Group> groups;
  final String searchQuery;
  // Groups the user is already in, before or after tapping "Add".
  final Set<String> addedIds;
  final UiError? error;

  const AddToGroupState({
    required this.status,
    required this.allGroups,
    required this.groups,
    required this.searchQuery,
    required this.addedIds,
    this.error,
  });

  const AddToGroupState.initialState()
      : status = AddToGroupStatus.loading,
        allGroups = const [],
        groups = const [],
        searchQuery = '',
        addedIds = const {},
        error = null;

  AddToGroupState copyWith({
    AddToGroupStatus? status,
    List<Group>? allGroups,
    List<Group>? groups,
    String? searchQuery,
    Set<String>? addedIds,
    UiError? error,
  }) {
    return AddToGroupState(
      status: status ?? this.status,
      allGroups: allGroups ?? this.allGroups,
      groups: groups ?? this.groups,
      searchQuery: searchQuery ?? this.searchQuery,
      addedIds: addedIds ?? this.addedIds,
      error: error ?? this.error,
    );
  }
}
